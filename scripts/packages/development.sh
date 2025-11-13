#!/usr/bin/env bash

# Development tools installation

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common.sh"

install_development_tools() {
    log_info "Installing development tools..."
    echo ""

    local packages=(
        "docker"
        "lazydocker"
        "lazygit"
        "neovim"
    )

    install_packages "${packages[@]}"

    # Enable and start docker service
    if is_installed "docker"; then
        if ! systemctl is-enabled docker &>/dev/null; then
            log_info "Enabling Docker service..."
            sudo systemctl enable docker
        fi

        if ! systemctl is-active docker &>/dev/null; then
            log_info "Starting Docker service..."
            sudo systemctl start docker
        fi

        # Add user to docker group if not already
        if ! groups | grep -q docker; then
            log_info "Adding $USER to docker group..."
            sudo usermod -aG docker "$USER"
            log_warning "You'll need to log out and back in for docker group to take effect"
        fi
    fi
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_development_tools
fi
