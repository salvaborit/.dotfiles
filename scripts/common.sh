#!/usr/bin/env bash

# Common functions for installation scripts
# Source this file from other scripts: source "$(dirname "${BASH_SOURCE[0]}")/../common.sh"

# Color codes for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Logging functions
log_info() {
    echo -e "${BLUE}→${NC} $1"
}

log_success() {
    echo -e "${GREEN}✓${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}!${NC} $1"
}

log_error() {
    echo -e "${RED}✗${NC} $1"
}

# Check if package is installed via pacman
is_installed() {
    pacman -Qi "$1" &>/dev/null
}

# Check if command exists in PATH
command_exists() {
    command -v "$1" &>/dev/null
}

# Install pacman packages with checking
install_packages() {
    local packages=("$@")
    local to_install=()

    for pkg in "${packages[@]}"; do
        if is_installed "$pkg"; then
            log_success "$pkg is already installed"
        else
            log_info "$pkg will be installed"
            to_install+=("$pkg")
        fi
    done

    if [ ${#to_install[@]} -gt 0 ]; then
        echo ""
        log_info "Installing ${#to_install[@]} package(s)..."
        if sudo pacman -S --needed --noconfirm "${to_install[@]}"; then
            log_success "Package installation complete!"
        else
            log_error "Package installation failed"
            return 1
        fi
    else
        log_success "All packages already installed"
    fi

    return 0
}

# Ask yes/no question
ask_yes_no() {
    local prompt="$1"
    local response

    while true; do
        read -p "$prompt (y/n): " response
        case "$response" in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer y or n.";;
        esac
    done
}

# Configure git identity
configure_git() {
    log_info "Git identity configuration"
    echo ""

    # Check if git is already configured
    local current_name=$(git config --global user.name 2>/dev/null)
    local current_email=$(git config --global user.email 2>/dev/null)

    if [[ -n $current_name ]] && [[ -n $current_email ]]; then
        log_success "Git is already configured:"
        echo "  Name:  $current_name"
        echo "  Email: $current_email"
        echo ""
        if ! ask_yes_no "Reconfigure git identity?"; then
            return 0
        fi
        echo ""
    fi

    # Prompt for name
    local git_name
    while true; do
        read -p "Enter your git user.name: " git_name
        if [[ -n $git_name ]]; then
            break
        else
            log_warning "Name cannot be empty"
        fi
    done

    # Prompt for email
    local git_email
    while true; do
        read -p "Enter your git user.email: " git_email
        if [[ -n $git_email ]]; then
            break
        else
            log_warning "Email cannot be empty"
        fi
    done

    # Set git config
    git config --global user.name "$git_name"
    git config --global user.email "$git_email"

    log_success "Git identity configured:"
    echo "  Name:  $git_name"
    echo "  Email: $git_email"
    echo ""
}

# Install yay AUR helper if not present
install_yay() {
    if command_exists yay; then
        log_success "yay is already installed"
        return 0
    fi

    log_info "Installing yay AUR helper..."

    # Install dependencies
    if ! is_installed "base-devel" || ! is_installed "git"; then
        log_info "Installing yay dependencies..."
        sudo pacman -S --needed base-devel git
    fi

    # Clone and build yay
    local temp_dir=$(mktemp -d)
    cd "$temp_dir"

    if git clone https://aur.archlinux.org/yay.git; then
        cd yay
        if makepkg -si --noconfirm; then
            log_success "yay installed successfully"
            cd - > /dev/null
            rm -rf "$temp_dir"
            return 0
        else
            log_error "Failed to build yay"
            cd - > /dev/null
            rm -rf "$temp_dir"
            return 1
        fi
    else
        log_error "Failed to clone yay repository"
        rm -rf "$temp_dir"
        return 1
    fi
}

# Install AUR packages with yay
install_aur_packages() {
    local packages=("$@")
    local to_install=()

    # Ensure yay is installed
    if ! command_exists yay; then
        install_yay || return 1
    fi

    for pkg in "${packages[@]}"; do
        if is_installed "$pkg"; then
            log_success "$pkg is already installed"
        else
            log_info "$pkg will be installed (AUR)"
            to_install+=("$pkg")
        fi
    done

    if [ ${#to_install[@]} -gt 0 ]; then
        echo ""
        log_info "Installing ${#to_install[@]} AUR package(s)..."
        if yay -S --needed --noconfirm "${to_install[@]}"; then
            log_success "AUR package installation complete!"
        else
            log_error "AUR package installation failed"
            return 1
        fi
    else
        log_success "All AUR packages already installed"
    fi

    return 0
}
