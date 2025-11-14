#!/usr/bin/env bash

# Core system packages installation

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common.sh"

install_core_packages() {
    log_info "Installing core system packages..."
    echo ""

    local packages=(
        "git"
        "base-devel"
        "vim"
        "tree"
        "unzip"
        "less"
        "ufw"
    )

    install_packages "${packages[@]}"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    start_timer "$(basename "$0")"
    if install_core_packages; then
        end_timer "success"
    else
        end_timer "failed"
    fi
fi
