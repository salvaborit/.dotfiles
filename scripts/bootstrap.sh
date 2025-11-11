#!/usr/bin/env bash
# Main bootstrap script for dotfiles installation
# Orchestrates package installation and stow setup

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "====================================="
echo "SBA Dotfiles Bootstrap"
echo "====================================="
echo ""
echo "Dotfiles directory: $DOTFILES_DIR"
echo ""

usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Bootstrap dotfiles installation.

OPTIONS:
    -h, --help              Show this help message
    -s, --skip-packages     Skip package installation
    -p, --packages-only     Only install packages, skip stow
    -m, --minimal           Install only core and terminal packages
    -f, --full              Install all packages (default)

INSTALLATION CATEGORIES:
    Core utilities:     vim, tree, unzip, ufw
    Terminal tools:     alacritty, starship
    Docker tools:       docker, lazydocker, lazygit
    GUI apps:           obsidian
    Wayland desktop:    waybar
    Audio tools:        sonic-pi, supercollider

EXAMPLES:
    $0                      # Full installation (all packages + stow)
    $0 --minimal            # Install core + terminal only
    $0 --packages-only      # Install packages without stowing
    $0 --skip-packages      # Only stow configs (packages already installed)

EOF
}

install_core_utils() {
    echo "====================================="
    echo "Installing Core Utilities"
    echo "====================================="
    echo ""
    bash "$SCRIPT_DIR/install/core-utils.sh"
    echo ""
}

install_terminal() {
    echo "====================================="
    echo "Installing Terminal Tools"
    echo "====================================="
    echo ""
    bash "$SCRIPT_DIR/install/terminal.sh"
    echo ""
}

install_docker() {
    echo "====================================="
    echo "Installing Docker Tools"
    echo "====================================="
    echo ""
    bash "$SCRIPT_DIR/install/docker-tools.sh"
    echo ""
}

install_gui_apps() {
    echo "====================================="
    echo "Installing GUI Applications"
    echo "====================================="
    echo ""
    bash "$SCRIPT_DIR/install/gui-apps.sh"
    echo ""
}

install_wayland() {
    echo "====================================="
    echo "Installing Wayland Desktop"
    echo "====================================="
    echo ""
    bash "$SCRIPT_DIR/install/wayland-desktop.sh"
    echo ""
}

install_audio() {
    echo "====================================="
    echo "Installing Audio Tools"
    echo "====================================="
    echo ""
    bash "$SCRIPT_DIR/install/audio.sh"
    echo ""
}

stow_configs() {
    echo "====================================="
    echo "Stowing Configuration Files"
    echo "====================================="
    echo ""

    # Check if stow is installed
    if ! command -v stow &> /dev/null; then
        echo "→ GNU Stow not found, installing..."
        sudo pacman -S --needed --noconfirm stow
    fi

    # Stow default packages
    bash "$SCRIPT_DIR/stow-packages.sh" --default

    # Check for Omarchy and stow omarchy-specific configs
    if [ -d "$HOME/.config/omarchy" ]; then
        echo ""
        echo "→ Detected Omarchy, stowing omarchy package..."
        bash "$SCRIPT_DIR/stow-packages.sh" omarchy
    fi

    echo ""
}

run_optional_configs() {
    echo "====================================="
    echo "Optional Configurations"
    echo "====================================="
    echo ""

    # Omarchy Sonic Pi audio fix
    if [ -f "$DOTFILES_DIR/optional/omarchy-sonic-pi-fix.sh" ]; then
        bash "$DOTFILES_DIR/optional/omarchy-sonic-pi-fix.sh"
    fi

    echo ""
}

main() {
    local skip_packages=false
    local packages_only=false
    local minimal=false
    local full=true

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                usage
                exit 0
                ;;
            -s|--skip-packages)
                skip_packages=true
                shift
                ;;
            -p|--packages-only)
                packages_only=true
                shift
                ;;
            -m|--minimal)
                minimal=true
                full=false
                shift
                ;;
            -f|--full)
                full=true
                minimal=false
                shift
                ;;
            *)
                echo "Unknown option: $1"
                usage
                exit 1
                ;;
        esac
    done

    # Install packages
    if [ "$skip_packages" = false ]; then
        echo "Starting package installation..."
        echo ""

        # Always install core and terminal
        install_core_utils
        install_terminal

        # Full installation includes everything
        if [ "$full" = true ]; then
            install_docker
            install_gui_apps
            install_wayland
            install_audio
        fi

        echo "====================================="
        echo "Package Installation Complete"
        echo "====================================="
        echo ""
    else
        echo "Skipping package installation..."
        echo ""
    fi

    # Stow configurations
    if [ "$packages_only" = false ]; then
        stow_configs
        run_optional_configs
    fi

    echo "====================================="
    echo "Bootstrap Complete!"
    echo "====================================="
    echo ""

    if [ "$skip_packages" = false ] && [ "$full" = true ]; then
        echo "Next steps:"
        echo "  1. Log out and back in to apply group changes (docker)"
        echo "  2. Run 'source ~/.bashrc' to apply shell changes"
        echo "  3. Check stow status: ./scripts/stow-packages.sh --status"
        echo ""
    fi

    echo "Useful commands:"
    echo "  ./scripts/stow-packages.sh --help     # Manage stowed packages"
    echo "  ./scripts/stow-packages.sh --status   # Check what's stowed"
    echo "  ./scripts/stow-packages.sh --all      # Stow all packages"
    echo ""
}

main "$@"
