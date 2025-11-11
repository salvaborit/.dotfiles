#!/usr/bin/env bash
# Docker tools installation script

set -e

SCRIPT_NAME="Docker Tools"
PACKAGES=(
    "docker"
    "lazydocker"
    "lazygit"
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

configure_docker() {
    # Enable and start docker service
    if systemctl is-enabled docker &> /dev/null; then
        echo "✓ Docker service is already enabled"
    else
        echo "→ Enabling Docker service..."
        sudo systemctl enable docker
    fi

    if systemctl is-active docker &> /dev/null; then
        echo "✓ Docker service is running"
    else
        echo "→ Starting Docker service..."
        sudo systemctl start docker
    fi

    # Add user to docker group
    if groups | grep -q docker; then
        echo "✓ User is already in docker group"
    else
        echo "→ Adding user to docker group..."
        sudo usermod -aG docker "$USER"
        echo "⚠ Note: You need to log out and back in for docker group changes to take effect"
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

    # Verify commands are available
    for cmd in docker lazydocker lazygit; do
        if ! command -v "$cmd" &> /dev/null; then
            echo "⚠ Warning: $cmd not found in PATH"
        fi
    done

    echo "✓ All packages validated successfully"
    return 0
}

main() {
    install_packages
    echo ""
    configure_docker
    echo ""
    validate_installation
}

main "$@"
