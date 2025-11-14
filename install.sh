#!/usr/bin/env bash

# SBA dotfiles installation script
# Installs packages and deploys configs with GNU stow

set -e # Exit on error

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_DIR="$DOTFILES_DIR/scripts"

# Source common functions
source "$SCRIPT_DIR/common.sh"

echo "======================================"
echo "SBA Dotfiles Installation"
echo "Arch + Hyprland"
echo "======================================"
echo ""

# Configure git identity first
configure_git

# Check if stow is installed
if ! command_exists stow; then
  log_error "GNU stow is not installed!"
  log_info "Installing stow..."
  sudo pacman -S --needed stow
fi

# Install packages
log_info "Installing system packages..."
echo ""

bash "$SCRIPT_DIR/packages/core.sh"
echo ""

bash "$SCRIPT_DIR/packages/hyprland.sh"
echo ""

bash "$SCRIPT_DIR/packages/terminal.sh"
echo ""

bash "$SCRIPT_DIR/packages/development.sh"
echo ""

bash "$SCRIPT_DIR/packages/applications.sh"
echo ""

bash "$SCRIPT_DIR/packages/fonts.sh"
echo ""

bash "$SCRIPT_DIR/packages/claude.sh"
echo ""

# Optional audio stack
if ask_yes_no "Install audio stack (Sonic Pi + SuperCollider)?"; then
  bash "$SCRIPT_DIR/packages/audio.sh"
  echo ""
fi

# Deploy dotfiles with stow
log_info "Deploying dotfiles with GNU stow..."
echo ""

cd "$DOTFILES_DIR"

# Backup existing files that would conflict
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
BACKUP_NEEDED=false

# Function to backup file/directory if it exists and is not a symlink
backup_if_needed() {
  local path="$1"
  if [ -e "$path" ] && [ ! -L "$path" ]; then
    if [ "$BACKUP_NEEDED" = false ]; then
      mkdir -p "$BACKUP_DIR"
      log_info "Creating backup directory: $BACKUP_DIR"
      BACKUP_NEEDED=true
    fi

    local relative_path="${path#$HOME/}"
    local backup_path="$BACKUP_DIR/$relative_path"
    mkdir -p "$(dirname "$backup_path")"

    # Use cp -a to preserve structure for directories, then remove original
    if [ -d "$path" ]; then
      cp -a "$path" "$(dirname "$backup_path")/"
      rm -rf "$path"
      log_info "Backed up directory: ~/$relative_path"
    else
      mv "$path" "$backup_path"
      log_info "Backed up file: ~/$relative_path"
    fi
  fi
}

# Check and backup conflicting files/directories
log_info "Checking for conflicting files and directories..."
# Individual files that aren't symlinks
backup_if_needed "$HOME/.bashrc"
backup_if_needed "$HOME/.vimrc"

# For directories: only backup if they exist as real directories (not symlinks)
# This allows stow to create directory-level symlinks
for dir in \
  "$HOME/.config/hypr" \
  "$HOME/.config/alacritty" \
  "$HOME/.config/waybar" \
  "$HOME/.config/nvim" \
  "$HOME/.config/themes" \
  "$HOME/.config/rofi" \
  "$HOME/.local/bin"; do

  # Only backup if it's a real directory (not a symlink)
  if [ -d "$dir" ] && [ ! -L "$dir" ]; then
    # Check if this directory would conflict with stow
    # (i.e., stow wants to create it as a symlink)
    backup_if_needed "$dir"
  fi
done

# If backups were made, inform user
if [ "$BACKUP_NEEDED" = true ]; then
  echo ""
  log_success "Existing files backed up to: $BACKUP_DIR"
  echo ""
fi

# Stow packages
STOW_PACKAGES=(
  "shell"
  "hyprland"
  "waybar"
  "terminal"
  "neovim"
  "themes"
  "scripts-local"
  "applications"
  "rofi"
)

STOW_SUCCESS=()
STOW_FAILED=()

for package in "${STOW_PACKAGES[@]}"; do
  log_info "Stowing $package..."

  # First unstow to clean up any old symlinks, then restow fresh
  # This ensures clean deployment even if previous symlinks were broken
  stow --delete "$package" 2>/dev/null || true

  # Run stow and capture output
  # Use --restow to replace existing symlinks, --verbose to see what's happening
  # Use --no-folding for scripts-local to create individual file symlinks
  if [ "$package" = "scripts-local" ]; then
    stow_cmd="stow --restow --no-folding --verbose=2"
  else
    stow_cmd="stow --restow --verbose=2"
  fi

  if stow_output=$($stow_cmd "$package" 2>&1); then
    STOW_SUCCESS+=("$package")
    log_success "$package deployed"
  else
    STOW_FAILED+=("$package")
    log_error "$package failed to deploy"
    echo "$stow_output" | grep -i "conflict\|error" || true
  fi
done

echo ""

# Verify symlinks were created
log_info "Verifying symlink deployment..."
VERIFY_PATHS=(
  "$HOME/.bashrc:shell"
  "$HOME/.config/hypr/hyprland.conf:hyprland"
  "$HOME/.config/waybar:waybar"
  "$HOME/.config/alacritty:terminal"
  "$HOME/.config/nvim:neovim"
  "$HOME/.local/bin/screenshot:scripts-local"
  "$HOME/.config/themes:themes"
  "$HOME/.config/rofi:rofi"
)

VERIFY_SUCCESS=0
VERIFY_FAILED=0

for item in "${VERIFY_PATHS[@]}"; do
  path="${item%%:*}"
  package="${item##*:}"

  # Check if path is a symlink or exists under a symlinked directory
  if [ -L "$path" ]; then
    VERIFY_SUCCESS=$((VERIFY_SUCCESS + 1))
    log_success "✓ $path (package: $package)"
  elif [ -e "$path" ]; then
    VERIFY_FAILED=$((VERIFY_FAILED + 1))
    log_warning "✗ Not a symlink: $path (package: $package)"
  else
    VERIFY_FAILED=$((VERIFY_FAILED + 1))
    log_error "✗ Missing: $path (package: $package)"
  fi
done

echo ""
log_success "Symlinks verified: $VERIFY_SUCCESS/$((VERIFY_SUCCESS + VERIFY_FAILED)) successful"

if [ $VERIFY_FAILED -gt 0 ]; then
  log_warning "$VERIFY_FAILED items were not deployed properly"
else
  log_success "All dotfiles successfully deployed with GNU stow!"
fi

echo ""
log_success "Dotfiles deployment complete!"
echo ""

# Final instructions
echo "======================================"
echo "Installation Complete!"
echo "======================================"
echo ""
echo "Next steps:"
echo "  1. Log out and select 'Hyprland' at your display manager"
echo "  2. Or reboot for a clean start"
echo ""
echo "Tips:"
echo "  - Reload shell: source ~/.bashrc"
echo "  - Reload Hyprland: Super+Shift+R (if bound) or hyprctl reload"
echo "  - Reload Waybar: killall waybar && waybar &"
echo "  - Custom keybindings: See ~/.config/hypr/bindings.conf"
echo ""
echo "Configuration files:"
echo "  - Hyprland: ~/.config/hypr/"
echo "  - Waybar: ~/.config/waybar/"
echo "  - Shell: ~/.bashrc"
echo "  - Theme: ~/.config/themes/main-theme/"
echo ""

if groups | grep -q docker; then
  echo "Note: Docker group added. Log out and back in for it to take effect."
  echo ""
fi
