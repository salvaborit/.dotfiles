#!/usr/bin/env bash

# SBA dotfiles installation script
# installs packages and creates symlinks from ~ to dotfiles in this repository

set -e  # exit on error

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BACKUP_DIR="$HOME/.dotfiles_backup"

echo "====================================="
echo "SBA dotfiles install script"
echo "====================================="
echo ""

# packages to install
PACKAGES=(
        "vim"
        "ufw"
        "alacritty"
        "tree"
        "unzip"
        "obsidian"
        "waybar"
        "starship"
        "docker"
        "lazydocker"
        "lazygit"
        "sonic-pi"
        "supercollider"
        "jack-example-tools"
        "sc3-plugins"
)

echo "Installing packages..."
echo ""

PACKAGES_TO_INSTALL=()
for pkg in "${PACKAGES[@]}"; do
    if pacman -Qi "$pkg" &> /dev/null; then
        echo "✓ $pkg is already installed"
    else
        echo "→ $pkg will be installed"
        PACKAGES_TO_INSTALL+=("$pkg")
    fi
done

if [ ${#PACKAGES_TO_INSTALL[@]} -gt 0 ]; then
    echo ""
    echo "Installing ${#PACKAGES_TO_INSTALL[@]} package(s)..."
    sudo pacman -S --needed "${PACKAGES_TO_INSTALL[@]}"
    echo "Package installation complete!"
else
    echo "All packages are already installed!"
fi
echo ""

mkdir -p "$BACKUP_DIR"
echo "Backup directory: $BACKUP_DIR"
echo ""

mkdir -p "$HOME/.config"

create_symlink_with_backup() {
    local source="$1"
    local target="$2"
    local filename="$3"

    if [ ! -e "$source" ]; then
        echo "Warning: $filename not found in $DOTFILES_DIR, skipping..."
        return
    fi

    # if file/symlink exists in target loc
    if [ -e "$target" ] || [ -L "$target" ]; then
        # check if already correct symlink
        if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
            echo "✓ $filename is already correctly linked"
            return
        fi

        echo "→ Backing up existing $filename"
        mkdir -p "$(dirname "$BACKUP_DIR/$filename")"
        mv "$target" "$BACKUP_DIR/$filename"
    fi

    echo "→ Creating symlink: $filename"
    ln -s "$source" "$target"
}


# ALL symlinks
echo "Creating symlinks..."
create_symlink_with_backup "$DOTFILES_DIR/.bashrc" "$HOME/.bashrc" ".bashrc"
create_symlink_with_backup "$DOTFILES_DIR/.vimrc" "$HOME/.vimrc" ".vimrc"
create_symlink_with_backup "$DOTFILES_DIR/.config/starship.toml" "$HOME/.config/starship.toml" ".config/starship.toml"
create_symlink_with_backup "$DOTFILES_DIR/.config/waybar" "$HOME/.config/waybar" ".config/waybar"
create_symlink_with_backup "$DOTFILES_DIR/.config/hypr/looknfeel.conf" "$HOME/.config/hypr/looknfeel.conf" ".config/hypr/looknfeel.conf"
create_symlink_with_backup "$DOTFILES_DIR/.config/hypr/monitors.conf" "$HOME/.config/hypr/monitors.conf" ".config/hypr/monitors.conf"
create_symlink_with_backup "$DOTFILES_DIR/.config/hypr/hyprland.conf" "$HOME/.config/hypr/hyprland.conf" ".config/hypr/hyprland.conf"
create_symlink_with_backup "$DOTFILES_DIR/.config/hypr/bindings.conf" "$HOME/.config/hypr/bindings.conf" ".config/hypr/bindings.conf"
create_symlink_with_backup "$DOTFILES_DIR/.config/walker/config.toml" "$HOME/.config/walker/config.toml" ".config/walker/config.toml"
create_symlink_with_backup "$DOTFILES_DIR/.config/alacritty/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml" ".config/alacritty/alacritty.toml"
create_symlink_with_backup "$DOTFILES_DIR/.config/uwsm/default" "$HOME/.config/uwsm/default" ".config/uwsm/default"
create_symlink_with_backup "$DOTFILES_DIR/.config/omarchy/themes/omarchy-sba-00-theme" "$HOME/.config/omarchy/themes/omarchy-sba-00-theme" ".config/omarchy/themes/omarchy-sba-00-theme"

echo ""

# optional Omarchy-specific setups
echo "====================================="
echo "Optional Configurations"
echo "====================================="
echo ""

# sonic-pi audio fix for omarchy
if [ -f "$DOTFILES_DIR/optional/omarchy-sonic-pi-fix.sh" ]; then
    bash "$DOTFILES_DIR/optional/omarchy-sonic-pi-fix.sh"
fi

echo ""
echo "====================================="
echo "Installation complete!"
echo "====================================="
echo "Backups of original files are in: $BACKUP_DIR"
echo ""
echo "To apply changes, run: source ~/.bashrc"
