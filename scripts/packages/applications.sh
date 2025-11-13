#!/usr/bin/env bash

# User applications installation

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common.sh"

install_applications() {
    log_info "Installing user applications..."
    echo ""

    # Official repository packages
    local packages=(
        "obsidian"
        "nautilus"          # File manager
        "chromium"          # Web browser
    )

    install_packages "${packages[@]}"

    # Note: proton-pass removed from auto-install due to AUR checksum issues
    # Install manually if needed: yay -S proton-pass
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_applications
fi
