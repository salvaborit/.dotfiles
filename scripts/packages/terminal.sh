#!/usr/bin/env bash

# Terminal and shell tools installation

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common.sh"

install_terminal_stack() {
    log_info "Installing terminal and shell tools..."
    echo ""

    local packages=(
        "alacritty"
        "starship"
        "btop"
        "cava"
    )

    install_packages "${packages[@]}"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_terminal_stack
fi
