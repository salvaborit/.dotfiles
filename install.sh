#!/usr/bin/env bash

# SBA dotfiles installation script
# installs packages and creates symlinks from ~ to dotfiles in this repository

set -e  # exit on error

# get pwd
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# backup dir
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
)

# install packages
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

# create backup dir if not exists
mkdir -p "$BACKUP_DIR"
echo "Backup directory: $BACKUP_DIR"
echo ""

# create .config dir if not exists
mkdir -p "$HOME/.config"

create_symlink_with_backup() {
    local source="$1"
    local target="$2"
    local filename="$3"

    # check file exists in repo
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

        # backup existing
        echo "→ Backing up existing $filename"
        # create parent dir in backup if needed
        mkdir -p "$(dirname "$BACKUP_DIR/$filename")"
        mv "$target" "$BACKUP_DIR/$filename"
    fi

    # create symlink
    echo "→ Creating symlink: $filename"
    ln -s "$source" "$target"
}


# ALL symlinks
echo "Creating symlinks..."
create_symlink_with_backup "$DOTFILES_DIR/.bashrc" "$HOME/.bashrc" ".bashrc"
create_symlink_with_backup "$DOTFILES_DIR/.vimrc" "$HOME/.vimrc" ".vimrc"
create_symlink_with_backup "$DOTFILES_DIR/.config/starship.toml" "$HOME/.config/starship.toml" ".config/starship.toml"

echo ""
echo "====================================="
echo "Installation complete!"
echo "====================================="
echo "Backups of your original files are in: $BACKUP_DIR"
echo ""
echo "To apply changes, run: source ~/.bashrc"
