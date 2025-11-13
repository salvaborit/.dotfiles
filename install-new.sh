#!/usr/bin/env bash

# SBA dotfiles installation script
# Installs packages and deploys configs with GNU stow

set -e  # Exit on error

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_DIR="$DOTFILES_DIR/scripts"

# Source common functions
source "$SCRIPT_DIR/common.sh"

echo "======================================"
echo "SBA Dotfiles Installation"
echo "Arch + Hyprland"
echo "======================================"
echo ""

# Configure git identity first
configure_git

# Check if stow is installed
if ! command_exists stow; then
    log_error "GNU stow is not installed!"
    log_info "Installing stow..."
    sudo pacman -S --needed stow
fi

# Install packages
log_info "Installing system packages..."
echo ""

bash "$SCRIPT_DIR/packages/core.sh"
echo ""

bash "$SCRIPT_DIR/packages/hyprland.sh"
echo ""

bash "$SCRIPT_DIR/packages/terminal.sh"
echo ""

bash "$SCRIPT_DIR/packages/development.sh"
echo ""

bash "$SCRIPT_DIR/packages/applications.sh"
echo ""

bash "$SCRIPT_DIR/packages/fonts.sh"
echo ""

bash "$SCRIPT_DIR/packages/claude.sh"
echo ""

# Optional audio stack
if ask_yes_no "Install audio stack (Sonic Pi + SuperCollider)?"; then
    bash "$SCRIPT_DIR/packages/audio.sh"
    echo ""
fi

# Deploy dotfiles with stow
log_info "Deploying dotfiles with GNU stow..."
echo ""

cd "$DOTFILES_DIR"

# Stow packages
STOW_PACKAGES=(
    "shell"
    "hyprland"
    "waybar"
    "terminal"
    "walker"
    "themes"
    "scripts-local"
    "applications"
)

for package in "${STOW_PACKAGES[@]}"; do
    log_info "Stowing $package..."
    if stow -v "$package" 2>&1 | grep -q "LINK"; then
        log_success "$package deployed"
    else
        log_warning "$package may already be deployed"
    fi
done

echo ""
log_success "Dotfiles deployment complete!"
echo ""

# Final instructions
echo "======================================"
echo "Installation Complete!"
echo "======================================"
echo ""
echo "Next steps:"
echo "  1. Log out and select 'Hyprland' at your display manager"
echo "  2. Or reboot for a clean start"
echo ""
echo "Tips:"
echo "  - Reload shell: source ~/.bashrc"
echo "  - Reload Hyprland: Super+Shift+R (if bound) or hyprctl reload"
echo "  - Reload Waybar: killall waybar && waybar &"
echo "  - Custom keybindings: See ~/.config/hypr/bindings.conf"
echo ""
echo "Configuration files:"
echo "  - Hyprland: ~/.config/hypr/"
echo "  - Waybar: ~/.config/waybar/"
echo "  - Shell: ~/.bashrc"
echo "  - Theme: ~/.config/themes/main-theme/"
echo ""

if groups | grep -q docker; then
    echo "Note: Docker group added. Log out and back in for it to take effect."
    echo ""
fi
