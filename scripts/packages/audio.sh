#!/usr/bin/env bash

# Audio stack installation (Sonic Pi and related tools)
# This is optional and can be skipped

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common.sh"

install_audio_stack() {
    log_info "Installing audio stack (Sonic Pi)..."
    echo ""

    # Official repository packages
    local packages=(
        "supercollider"
        "pipewire"
        "pipewire-jack"
        "wireplumber"
    )

    install_packages "${packages[@]}"

    # AUR packages
    echo ""
    local aur_packages=(
        "sonic-pi"
        "jack-example-tools"
        "sc3-plugins"
    )

    install_aur_packages "${aur_packages[@]}"

    if is_installed "pipewire"; then
        log_info "Enabling audio services..."
        systemctl --user enable pipewire.service
        systemctl --user enable wireplumber.service
        log_success "Audio services enabled"
    fi
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_audio_stack
fi
