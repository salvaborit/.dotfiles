#!/usr/bin/env bash
# Wayland desktop environment installation script

set -e

SCRIPT_NAME="Wayland Desktop"
PACKAGES=(
    "waybar"
)

echo "====================================="
echo "$SCRIPT_NAME Installation"
echo "====================================="
echo ""

install_packages() {
    local packages_to_install=()

    for pkg in "${PACKAGES[@]}"; do
        if pacman -Qi "$pkg" &> /dev/null; then
            echo "✓ $pkg is already installed"
        else
            echo "→ $pkg will be installed"
            packages_to_install+=("$pkg")
        fi
    done

    if [ ${#packages_to_install[@]} -gt 0 ]; then
        echo ""
        echo "Installing ${#packages_to_install[@]} package(s)..."
        sudo pacman -S --needed --noconfirm "${packages_to_install[@]}"
        echo "✓ $SCRIPT_NAME packages installed successfully!"
    else
        echo "✓ All $SCRIPT_NAME packages are already installed!"
    fi
}

validate_installation() {
    local failed=()

    for pkg in "${PACKAGES[@]}"; do
        if ! pacman -Qi "$pkg" &> /dev/null; then
            failed+=("$pkg")
        fi
    done

    if [ ${#failed[@]} -gt 0 ]; then
        echo "✗ Failed to install: ${failed[*]}"
        return 1
    fi

    # Verify waybar is in PATH
    if ! command -v waybar &> /dev/null; then
        echo "⚠ Warning: waybar not found in PATH"
    fi

    echo "✓ All packages validated successfully"
    return 0
}

main() {
    install_packages
    echo ""
    validate_installation
}

main "$@"
