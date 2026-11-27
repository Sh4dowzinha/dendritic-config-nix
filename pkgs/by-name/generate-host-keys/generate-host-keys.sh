#!/usr/bin/env bash
set -euo pipefail

# Nitrokey-backed OpenPGP key used to protect host private keys.
NITROKEY_GPG_FINGERPRINT="${NITROKEY_GPG_FINGERPRINT:-57B947A6375A93BFE0489ACFC71894C085934296}"

TEMP_DIR=""

cleanup() {
    if [[ -n "$TEMP_DIR" && -d "$TEMP_DIR" ]]; then
        rm -rf "$TEMP_DIR"
    fi
}
trap cleanup EXIT

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >&2
}

error() {
    log "ERROR: $*"
    exit 1
}

usage() {
    local exit_code="${1:-1}"
    cat <<EOF
Usage: $(basename "$0") <hostname>

Generate an Ed25519 SSH host key for a new host and encrypt it
with the Nitrokey-backed GPG key.

Files are stored in:
  secrets/hosts/<hostname>/

Environment:
  NITROKEY_GPG_FINGERPRINT  Override the default GPG recipient fingerprint

Example:
  $(basename "$0") novacustom
EOF
    exit "$exit_code"
}

resolve_repo_root() {
    if command -v git >/dev/null 2>&1 && git rev-parse --show-toplevel >/dev/null 2>&1; then
        git rev-parse --show-toplevel
    else
        pwd
    fi
}

check_dependencies() {
    local missing=()

    command -v gpg >/dev/null 2>&1 || missing+=("gnupg")
    command -v ssh-keygen >/dev/null 2>&1 || missing+=("openssh")
    command -v mktemp >/dev/null 2>&1 || missing+=("coreutils")
    command -v install >/dev/null 2>&1 || missing+=("coreutils")

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

print_age_recipient() {
    local public_file="$1"

    if [[ -f "$public_file" ]] && command -v ssh-to-age >/dev/null 2>&1; then
        log "✓ Host Age recipient: $(ssh-to-age -i "$public_file")"
    fi
}

generate_host_key() {
    local hostname="$1"
    local host_dir="$2"

    local key_name="ssh_host_ed25519_key"
    local encrypted_file="$host_dir/${key_name}.gpg"
    local public_file="$host_dir/${key_name}.pub"

    # Never overwrite an existing encrypted host key.
    if [[ -f "$encrypted_file" ]]; then
        log "✓ Already exists: $encrypted_file"
        print_age_recipient "$public_file"
        return 0
    fi

    TEMP_DIR="$(mktemp -d)"
    local temp_key="$TEMP_DIR/$key_name"
    local temp_encrypted="$TEMP_DIR/${key_name}.gpg"

    log "Generating ed25519 host key for: $hostname"

    if ! ssh-keygen \
        -t ed25519 \
        -f "$temp_key" \
        -N "" \
        -C "root@$hostname" \
        >/dev/null; then
        error "Failed to generate $key_name"
    fi

    log "✓ Generated $key_name"
    log "Encrypting $key_name with Nitrokey GPG key"

    if ! gpg \
        --batch \
        --yes \
        --recipient "$NITROKEY_GPG_FINGERPRINT" \
        --output "$temp_encrypted" \
        --encrypt \
        "$temp_key"; then
        error "Failed to encrypt $key_name"
    fi

    install -m 0600 "$temp_encrypted" "$encrypted_file"
    install -m 0644 "${temp_key}.pub" "$public_file"

    log "✓ Encrypted: $encrypted_file"
    log "✓ Public key: $public_file"
    print_age_recipient "$public_file"
}

main() {
    if [[ $# -ne 1 ]]; then
        usage 1
    fi

    case "$1" in
    -h | --help)
        usage 0
        ;;
    esac

    local hostname="$1"

    if [[ ! "$hostname" =~ ^[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?$ ]]; then
        error "Invalid hostname: $hostname"
    fi

    local repo_root host_dir
    repo_root="$(resolve_repo_root)"
    host_dir="$repo_root/secrets/hosts/$hostname"

    log "Starting SSH host key generation for: $hostname"

    check_dependencies
    check_gpg_key

    mkdir -p "$host_dir"
    generate_host_key "$hostname" "$host_dir"

    log "Successfully generated host key for: $hostname"
    log "Keys stored in: $host_dir"
}

main "$@"
