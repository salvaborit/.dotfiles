#!/usr/bin/env bash

# Development tools installation

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common.sh"

install_development_tools() {
  log_info "Installing development tools..."
  echo ""

  local packages=(
    "docker"
    "docker-compose"
    "docker-buildx"
    "lazydocker"
    "lazygit"
    "neovim"

    "jdk21-openjdk"
    "jdk-openjdk"
    "maven"

    "nodejs-lts-jod"
    "npm"

    "dbeaver"
  )

  install_packages "${packages[@]}"

  # AUR packages
  echo ""
  local aur_packages=(
    "postman-bin"
    "intellij-idea-ultimate-edition"
  )

  install_aur_packages "${aur_packages[@]}"

  # Configure docker socket activation (start on-demand, not at boot)
  if is_installed "docker"; then
    # Disable service auto-start
    if systemctl is-enabled docker &>/dev/null; then
      log_info "Disabling docker.service auto-start..."
      sudo systemctl disable docker
    fi

    # Stop the service if running
    if systemctl is-active docker &>/dev/null; then
      log_info "Stopping docker.service..."
      sudo systemctl stop docker
    fi

    # Enable socket activation
    if ! systemctl is-enabled docker.socket &>/dev/null; then
      log_info "Enabling docker.socket for on-demand activation..."
      sudo systemctl enable docker.socket
    fi

    if ! systemctl is-active docker.socket &>/dev/null; then
      log_info "Starting docker.socket..."
      sudo systemctl start docker.socket
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
  start_timer "$(basename "$0")"
  if install_development_tools; then
    end_timer "success"
  else
    end_timer "failed"
  fi
fi
