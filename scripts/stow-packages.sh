#!/usr/bin/env bash
# GNU Stow package management script
# Manages symlinking of dotfiles packages using GNU Stow

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PACKAGES_DIR="$DOTFILES_DIR/packages"
BACKUP_DIR="$HOME/.dotfiles_backup"

# Available packages
AVAILABLE_PACKAGES=(
    "bash"
    "vim"
    "alacritty"
    "starship"
    "hypr"
    "waybar"
    "walker"
    "uwsm"
    "omarchy"
    "sonic-pi"
)

# Default packages to install (commonly used)
DEFAULT_PACKAGES=(
    "bash"
    "vim"
    "alacritty"
    "starship"
)

usage() {
    cat << EOF
Usage: $0 [OPTIONS] [PACKAGES...]

Manage dotfiles using GNU Stow.

OPTIONS:
    -h, --help          Show this help message
    -l, --list          List available packages
    -a, --all           Stow all available packages
    -d, --default       Stow default packages (bash, vim, alacritty, starship)
    -u, --unstow        Unstow specified packages
    -r, --restow        Restow specified packages (unstow then stow)
    -s, --status        Show which packages are currently stowed

PACKAGES:
    Specific packages to stow: ${AVAILABLE_PACKAGES[*]}

EXAMPLES:
    $0 -d                  # Stow default packages
    $0 -a                  # Stow all packages
    $0 bash vim            # Stow only bash and vim
    $0 -u bash             # Unstow bash package
    $0 -r hypr waybar      # Restow hypr and waybar packages
    $0 -s                  # Show stow status

NOTES:
    - Stow must be installed: sudo pacman -S stow
    - Packages are symlinked from $PACKAGES_DIR to $HOME
    - Backups of existing files are stored in $BACKUP_DIR
EOF
}

check_stow_installed() {
    if ! command -v stow &> /dev/null; then
        echo "Error: GNU Stow is not installed"
        echo "Install it with: sudo pacman -S stow"
        exit 1
    fi
}

list_packages() {
    echo "Available packages:"
    for pkg in "${AVAILABLE_PACKAGES[@]}"; do
        if [ -d "$PACKAGES_DIR/$pkg" ]; then
            echo "  ✓ $pkg"
        else
            echo "  ✗ $pkg (directory missing)"
        fi
    done
}

backup_conflicts() {
    local package="$1"
    local package_dir="$PACKAGES_DIR/$package"

    if [ ! -d "$package_dir" ]; then
        return
    fi

    # Find all files in the package
    while IFS= read -r -d '' file; do
        local rel_path="${file#$package_dir/}"
        local target="$HOME/$rel_path"

        # If target exists and is not a symlink to our dotfiles
        if [ -e "$target" ] || [ -L "$target" ]; then
            if [ -L "$target" ]; then
                local link_target
                link_target=$(readlink "$target")
                if [[ "$link_target" == "$package_dir"* ]]; then
                    # Already linked correctly
                    continue
                fi
            fi

            # Backup the file
            echo "→ Backing up existing file: $rel_path"
            mkdir -p "$BACKUP_DIR/$(dirname "$rel_path")"
            mv "$target" "$BACKUP_DIR/$rel_path"
        fi
    done < <(find "$package_dir" -type f -print0)
}

stow_package() {
    local package="$1"

    if [ ! -d "$PACKAGES_DIR/$package" ]; then
        echo "✗ Package '$package' not found in $PACKAGES_DIR"
        return 1
    fi

    echo "→ Stowing $package..."
    backup_conflicts "$package"

    cd "$PACKAGES_DIR"
    if stow -v -t "$HOME" "$package" 2>&1 | grep -v "BUG in find_stowed_path"; then
        echo "✓ $package stowed successfully"
        return 0
    else
        echo "✗ Failed to stow $package"
        return 1
    fi
}

unstow_package() {
    local package="$1"

    if [ ! -d "$PACKAGES_DIR/$package" ]; then
        echo "✗ Package '$package' not found in $PACKAGES_DIR"
        return 1
    fi

    echo "→ Unstowing $package..."
    cd "$PACKAGES_DIR"
    if stow -v -D -t "$HOME" "$package" 2>&1 | grep -v "BUG in find_stowed_path"; then
        echo "✓ $package unstowed successfully"
        return 0
    else
        echo "✗ Failed to unstow $package"
        return 1
    fi
}

restow_package() {
    local package="$1"

    echo "→ Restowing $package..."
    unstow_package "$package"
    stow_package "$package"
}

show_status() {
    echo "Stow status:"
    echo ""

    for pkg in "${AVAILABLE_PACKAGES[@]}"; do
        if [ ! -d "$PACKAGES_DIR/$pkg" ]; then
            echo "  ✗ $pkg (package missing)"
            continue
        fi

        # Check if any file from this package is stowed
        local stowed=false
        while IFS= read -r -d '' file; do
            local rel_path="${file#$PACKAGES_DIR/$pkg/}"
            local target="$HOME/$rel_path"

            if [ -L "$target" ]; then
                local link_target
                link_target=$(readlink "$target")
                if [[ "$link_target" == "$PACKAGES_DIR/$pkg"* ]]; then
                    stowed=true
                    break
                fi
            fi
        done < <(find "$PACKAGES_DIR/$pkg" -type f -print0 2>/dev/null || true)

        if [ "$stowed" = true ]; then
            echo "  ✓ $pkg (stowed)"
        else
            echo "  ○ $pkg (not stowed)"
        fi
    done
}

main() {
    local mode="stow"
    local packages=()
    local use_all=false
    local use_default=false

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                usage
                exit 0
                ;;
            -l|--list)
                list_packages
                exit 0
                ;;
            -a|--all)
                use_all=true
                shift
                ;;
            -d|--default)
                use_default=true
                shift
                ;;
            -u|--unstow)
                mode="unstow"
                shift
                ;;
            -r|--restow)
                mode="restow"
                shift
                ;;
            -s|--status)
                check_stow_installed
                show_status
                exit 0
                ;;
            -*)
                echo "Unknown option: $1"
                usage
                exit 1
                ;;
            *)
                packages+=("$1")
                shift
                ;;
        esac
    done

    check_stow_installed
    mkdir -p "$BACKUP_DIR"

    # Determine which packages to process
    if [ "$use_all" = true ]; then
        packages=("${AVAILABLE_PACKAGES[@]}")
    elif [ "$use_default" = true ]; then
        packages=("${DEFAULT_PACKAGES[@]}")
    elif [ ${#packages[@]} -eq 0 ]; then
        echo "Error: No packages specified"
        echo ""
        usage
        exit 1
    fi

    # Process packages
    echo "====================================="
    echo "GNU Stow Package Management"
    echo "====================================="
    echo ""
    echo "Mode: $mode"
    echo "Packages: ${packages[*]}"
    echo ""

    local success_count=0
    local fail_count=0

    for pkg in "${packages[@]}"; do
        case $mode in
            stow)
                if stow_package "$pkg"; then
                    ((success_count++))
                else
                    ((fail_count++))
                fi
                ;;
            unstow)
                if unstow_package "$pkg"; then
                    ((success_count++))
                else
                    ((fail_count++))
                fi
                ;;
            restow)
                if restow_package "$pkg"; then
                    ((success_count++))
                else
                    ((fail_count++))
                fi
                ;;
        esac
        echo ""
    done

    echo "====================================="
    echo "Summary: $success_count succeeded, $fail_count failed"
    echo "====================================="

    if [ -d "$BACKUP_DIR" ] && [ -n "$(ls -A "$BACKUP_DIR" 2>/dev/null)" ]; then
        echo ""
        echo "Backups stored in: $BACKUP_DIR"
    fi
}

main "$@"
