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
        "rofi"                          # Application launcher
        "mako"                          # Notification daemon
        "swaylock"                      # Screen lock
        "hypridle"                      # Idle management
        "hyprlock"                      # Screen locker
        "hyprsunset"                    # Screen temperature control
        "swaybg"                        # Wallpaper daemon
        "grim"                          # Screenshot utility
        "slurp"                         # Region selector
        "satty"                         # Screenshot annotation
        "jq"                            # JSON processor for scripts
        "wl-clipboard"                  # Clipboard manager
        "polkit-kde-agent"              # Polkit authentication
        "xdg-desktop-portal-hyprland"   # Desktop portal
        "qt5-wayland"                   # Qt5 Wayland support
        "qt6-wayland"                   # Qt6 Wayland support
        "xorg-xwayland"                 # X11 compatibility
        "blueberry"                     # Bluetooth manager GUI
        "wiremix"                       # Audio mixer for PipeWire/PulseAudio
        "imagemagick"                   # Image processing
        "ffmpeg"                        # Video processing (for screenrecord)
        "v4l-utils"                     # Webcam support (for screenrecord)
    )

    install_packages "${packages[@]}"

    # AUR packages
    echo ""
    local aur_packages=(
        "gpu-screen-recorder"           # Hardware-accelerated screen recording
        "wayfreeze"                     # Screen freeze for screenshots
    )

    install_aur_packages "${aur_packages[@]}"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_hyprland_stack
fi
