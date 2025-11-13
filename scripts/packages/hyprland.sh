#!/usr/bin/env bash

# Hyprland and window manager stack installation

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common.sh"

install_hyprland_stack() {
    log_info "Installing Hyprland and window manager tools..."
    echo ""

    # Official repository packages
    local packages=(
        "hyprland"
        "waybar"
        "mako"                          # Notification daemon
        "swaylock"                      # Screen lock
        "grim"                          # Screenshot utility
        "slurp"                         # Region selector
        "wl-clipboard"                  # Clipboard manager
        "polkit-kde-agent"              # Polkit authentication
        "xdg-desktop-portal-hyprland"   # Desktop portal
        "qt5-wayland"                   # Qt5 Wayland support
        "qt6-wayland"                   # Qt6 Wayland support
    )

    install_packages "${packages[@]}"

    # AUR packages
    echo ""
    local aur_packages=(
        "walker"                        # Application launcher
    )

    install_aur_packages "${aur_packages[@]}"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_hyprland_stack
fi
