#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(pwd)"
KEYS_DIR="$REPO_ROOT/secrets/users"

# Nitrokey-backed OpenPGP key used to protect user private keys.
NITROKEY_GPG_FINGERPRINT="57B947A6375A93BFE0489ACFC71894C085934296"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >&2
}

error() {
    log "ERROR: $*"
    exit 1
}

usage() {
    echo "Usage: $0 <username>"
    echo
    echo "Generate an Age keypair for a user, encrypt a backup with the"
    echo "Nitrokey-backed GPG key, and install it to ~/.config/sops/age/keys.txt"
    echo "if run by that user."
    echo
    echo "Files are stored in:"
    echo "  secrets/users/<username>/"
    echo
    echo "Example:"
    echo "  $0 sh4dow"
    exit 1
}

check_dependencies() {
    local missing=()

    command -v gpg >/dev/null || missing+=("gnupg")
    command -v age-keygen >/dev/null || missing+=("age")
    command -v mktemp >/dev/null || missing+=("coreutils")

    if [[ ${#missing[@]} -gt 0 ]]; then
        error "Missing required dependencies: ${missing[*]}"
    fi
}

check_gpg_key() {
    log "Checking Nitrokey GPG key..."

    if ! gpg --list-keys "$NITROKEY_GPG_FINGERPRINT" >/dev/null 2>&1; then
        error "Could not find GPG key: $NITROKEY_GPG_FINGERPRINT"
    fi

    log "✓ Found GPG key: $NITROKEY_GPG_FINGERPRINT"
}

generate_user_key() {
    local username="$1"
    local user_dir="$KEYS_DIR/$username"

    local encrypted_file="$user_dir/age_key.gpg"
    local public_file="$user_dir/age_key.pub"

    if [[ -f "$encrypted_file" ]]; then
        log "✓ Already exists: $encrypted_file"
        if [[ -f "$public_file" ]]; then
            log "✓ Public key: $(cat "$public_file")"
        fi
        return 0
    fi

    local temp_dir
    temp_dir="$(mktemp -d)"
    local temp_key="$temp_dir/keys.txt"

    log "Generating Age keypair for user: $username"

    if ! age-keygen -o "$temp_key" >/dev/null 2>&1; then
        rm -rf "$temp_dir"
        error "Failed to generate Age key for $username"
    fi

    local pub_key
    pub_key="$(age-keygen -y "$temp_key")"

    log "✓ Generated Age keypair"
    log "Encrypting Age private key with Nitrokey GPG key"

    if ! gpg \
        --batch \
        --yes \
        --recipient "$NITROKEY_GPG_FINGERPRINT" \
        --output "$encrypted_file" \
        --encrypt \
        "$temp_key"; then
        rm -rf "$temp_dir"
        rm -f "$encrypted_file"
        error "Failed to encrypt Age key for $username"
    fi

    chmod 600 "$encrypted_file"

    echo "$pub_key" >"$public_file"
    chmod 644 "$public_file"

    # If generating for the current active user, install to ~/.config/sops/age/keys.txt
    if [[ "$username" == "${USER:-}" ]]; then
        local local_age_dir="${XDG_CONFIG_HOME:-$HOME/.config}/sops/age"
        local local_key_file="$local_age_dir/keys.txt"

        mkdir -p "$local_age_dir"
        chmod 700 "$local_age_dir"

        if [[ ! -f "$local_key_file" ]]; then
            cp "$temp_key" "$local_key_file"
            chmod 600 "$local_key_file"
            log "✓ Installed active key to: $local_key_file"
        else
            log "✓ Local key already present at: $local_key_file (not overwritten)"
        fi
    fi

    rm -rf "$temp_dir"

    log "✓ Encrypted backup: $encrypted_file"
    log "✓ Public key file:  $public_file"
    log "✓ Age recipient:    $pub_key"
}

main() {
    if [[ $# -ne 1 ]]; then
        usage
    fi

    local username="$1"

    if [[ ! "$username" =~ ^[a-z_][a-z0-9_-]*$ ]]; then
        error "Invalid username: $username"
    fi

    log "Starting Age key generation for user: $username"

    check_dependencies
    check_gpg_key

    mkdir -p "$KEYS_DIR/$username"

    generate_user_key "$username"

    log "Successfully generated user Age key for: $username"
}

main "$@"
