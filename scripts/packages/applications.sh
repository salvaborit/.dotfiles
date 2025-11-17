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
    "fastfetch"
    "nautilus"
    "chromium"
    "libreoffice-still"
    "spotify-launcher"
    "discord"
  )

  install_packages "${packages[@]}"

  # AUR packages
  echo ""
  local aur_packages=(
    "satty" # Screenshot annotation tool
    "slack-desktop"
    "localsend-bin"
    "teams-for-linux"
    "forticlient-vpn"
  )

  install_aur_packages "${aur_packages[@]}"

  # Note: proton-pass removed from auto-install due to AUR checksum issues
  # Install manually if needed: yay -S proton-pass
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  start_timer "$(basename "$0")"
  if install_applications; then
    end_timer "success"
  else
    end_timer "failed"
  fi
fi
