#!/usr/bin/env bash

# Font installation

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common.sh"

install_fonts() {
    log_info "Installing fonts..."
    echo ""

    # Install nerd fonts from pacman
    local packages=(
        "ttf-cascadia-code-nerd"
        "ttf-firacode-nerd"
        "ttf-jetbrains-mono-nerd"
    )

    install_packages "${packages[@]}"

    # Install custom SF Mono fonts if present in dotfiles
    local dotfiles_dir="$(cd "$SCRIPT_DIR/../.." && pwd)"
    local fonts_dir="$dotfiles_dir/fonts/SF-Mono-Nerd-Font-master"

    if [ -d "$fonts_dir" ]; then
        log_info "Installing SF Mono Nerd Font from dotfiles..."
        mkdir -p ~/.local/share/fonts
        cp "$fonts_dir"/*.otf ~/.local/share/fonts/ 2>/dev/null || true
        fc-cache -f
        log_success "SF Mono Nerd Font installed"
    else
        log_warning "SF Mono Nerd Font directory not found in dotfiles, skipping"
    fi
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_fonts
fi
