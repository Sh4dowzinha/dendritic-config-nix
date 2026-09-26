#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(pwd)"
KEYS_DIR="$REPO_ROOT/secrets/hosts"

# Nitrokey-backed OpenPGP key used to protect host private keys.
#
NITROKEY_GPG_FINGERPRINT="57B947A6375A93BFE0489ACFC71894C085934296"   # TODO -- Use variable substitution

KEY_TYPES=("ed25519" "rsa")

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >&2
}

error() {
    log "ERROR: $*"
    exit 1
}

usage() {
    echo "Usage: $0 <hostname>"
    echo
    echo "Generate SSH host keys for a new host and encrypt them"
    echo "with the Nitrokey-backed GPG key."
    echo
    echo "Files are stored in:"
    echo "  secrets/hosts/<hostname>/"
    echo
    echo "Example:"
    echo "  $0 novacustom"
    exit 1
}

check_dependencies() {
    local missing=()

    command -v gpg >/dev/null || missing+=("gnupg")
    command -v ssh-keygen >/dev/null || missing+=("openssh")
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

generate_host_key() {
    local hostname="$1"
    local key_type="$2"
    local host_dir="$KEYS_DIR/$hostname"

    local key_name="ssh_host_${key_type}_key"
    local encrypted_file="$host_dir/${key_name}.gpg"
    local public_file="$host_dir/${key_name}.pub"

    # Never overwrite an existing encrypted host key.
    if [[ -f "$encrypted_file" ]]; then
        log "✓ Already exists: $encrypted_file"
        return 0
    fi

    local temp_dir
    temp_dir="$(mktemp -d)"

    local temp_key="$temp_dir/$key_name"

    log "Generating $key_type host key for: $hostname"

    case "$key_type" in
        ed25519)
            if ! ssh-keygen \
                -t ed25519 \
                -f "$temp_key" \
                -N "" \
                -C "root@$hostname" \
                >/dev/null
            then
                rm -rf "$temp_dir"
                error "Failed to generate $key_name"
            fi
            ;;

        rsa)
            if ! ssh-keygen \
                -t rsa \
                -b 4096 \
                -f "$temp_key" \
                -N "" \
                -C "root@$hostname" \
                >/dev/null
            then
                rm -rf "$temp_dir"
                error "Failed to generate $key_name"
            fi
            ;;

        *)
            rm -rf "$temp_dir"
            error "Unsupported key type: $key_type"
            ;;
    esac

    log "✓ Generated $key_name"

    log "Encrypting $key_name with Nitrokey GPG key"

    if ! gpg \
        --batch \
        --yes \
        --recipient "$NITROKEY_GPG_FINGERPRINT" \
        --output "$encrypted_file" \
        --encrypt \
        "$temp_key"
    then
        rm -rf "$temp_dir"
        rm -f "$encrypted_file"
        error "Failed to encrypt $key_name"
    fi

    chmod 600 "$encrypted_file"

    if ! cp "${temp_key}.pub" "$public_file"; then
        rm -rf "$temp_dir"
        rm -f "$encrypted_file"
        error "Failed to store public key: $public_file"
    fi

    chmod 644 "$public_file"

    rm -rf "$temp_dir"

    log "✓ Encrypted: $encrypted_file"
    log "✓ Public key: $public_file"
}

main() {
    if [[ $# -ne 1 ]]; then
        usage
    fi

    local hostname="$1"

    if [[ ! "$hostname" =~ ^[a-zA-Z0-9][a-zA-Z0-9-]*[a-zA-Z0-9]$|^[a-zA-Z0-9]$ ]]; then
        error "Invalid hostname: $hostname"
    fi

    log "Starting SSH host key generation for: $hostname"

    check_dependencies
    check_gpg_key

    mkdir -p "$KEYS_DIR/$hostname"

    for key_type in "${KEY_TYPES[@]}"; do
        generate_host_key "$hostname" "$key_type"
    done

    log "Successfully generated host keys for: $hostname"
    log "Keys stored in: $KEYS_DIR/$hostname"
}

main "$@"
