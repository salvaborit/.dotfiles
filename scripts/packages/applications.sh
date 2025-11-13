#!/usr/bin/env bash

# User applications installation

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common.sh"

install_applications() {
    log_info "Installing user applications..."
    echo ""

    local packages=(
        "obsidian"
        "nautilus"          # File manager
        "chromium"          # Web browser
        "proton-pass"       # Password manager
    )

    install_packages "${packages[@]}"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_applications
fi
