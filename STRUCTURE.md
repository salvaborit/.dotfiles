# Dotfiles Structure

Complete directory structure after stow-based migration.

## Overview

```
dotfiles/
├── install-new.sh          # Master installation script
├── README-NEW.md           # Documentation
├── MIGRATION.md            # Migration guide from Omarchy
├── STRUCTURE.md            # This file
├── CLAUDE.md               # AI assistant instructions
│
├── scripts/                # Installation scripts
│   ├── common.sh          # Shared functions (logging, package checks)
│   ├── packages/          # Modular package installers
│   │   ├── core.sh       # Base system (git, vim, etc)
│   │   ├── hyprland.sh   # Window manager stack
│   │   ├── terminal.sh   # Terminal tools
│   │   ├── development.sh # Dev tools
│   │   ├── applications.sh # User apps
│   │   ├── fonts.sh      # Font installation
│   │   ├── audio.sh      # Sonic Pi stack (optional)
│   │   └── claude.sh     # Claude Code CLI
│   └── post-install/      # Post-installation tasks
│
├── shell/                  # STOW PACKAGE
│   ├── .bashrc
│   └── .vimrc
│
├── hyprland/               # STOW PACKAGE
│   └── .config/hypr/
│       ├── hyprland.conf  # Main config
│       ├── bindings.conf  # Keybindings
│       ├── monitors.conf  # Monitor setup
│       ├── looknfeel.conf # Appearance
│       ├── input.conf     # Keyboard/mouse
│       ├── envs.conf      # Environment variables
│       └── autostart.conf # Startup apps
│
├── waybar/                 # STOW PACKAGE
│   └── .config/waybar/
│       ├── config.jsonc   # Waybar config
│       ├── style.css      # Styling
│       └── scripts/       # Custom scripts
│           ├── cava.sh
│           └── ipaddr.sh
│
├── terminal/               # STOW PACKAGE
│   └── .config/
│       ├── alacritty/
│       │   └── alacritty.toml
│       └── starship.toml
│
├── walker/                 # STOW PACKAGE
│   └── .config/walker/
│       └── config.toml
│
├── themes/                 # STOW PACKAGE
│   └── .config/themes/
│       └── main-theme/
│           ├── README.md
│           ├── colors.conf
│           ├── wallpapers/
│           ├── alacritty/
│           ├── waybar/
│           ├── hyprland/
│           ├── walker/
│           ├── btop/
│           └── mako/
│
├── scripts-local/          # STOW PACKAGE
│   └── .local/bin/
│       ├── launch-or-focus
│       ├── launch-browser
│       ├── launch-terminal-cwd
│       ├── launch-webapp
│       ├── launch-or-focus-webapp
│       ├── sonic-pi-with-audio
│       └── supercollider-autoconnect.sh
│
├── applications/           # STOW PACKAGE
│   └── .local/share/applications/
│       └── sonic-pi.desktop
│
├── fonts/                  # NOT STOWED (installed via script)
│   └── SF-Mono-Nerd-Font-master/
│
└── [old files]             # To be archived after migration
    ├── install.sh          # Old installer
    ├── .config/            # Old configs
    ├── .bashrc             # Old shell config
    ├── .vimrc              # Old vim config
    ├── .local/             # Old scripts
    └── backgrounds/        # Old wallpapers (moved to theme)
```

## Stow Packages Explained

### shell
**Target**: Home directory
**Contents**: Shell configuration files
**Deploy**: `stow shell`

### hyprland
**Target**: ~/.config/hypr/
**Contents**: All Hyprland window manager configs
**Deploy**: `stow hyprland`
**Modular files**: Each aspect (bindings, monitors, appearance) in separate file

### waybar
**Target**: ~/.config/waybar/
**Contents**: Status bar configuration and scripts
**Deploy**: `stow waybar`

### terminal
**Target**: ~/.config/
**Contents**: Alacritty and Starship configs
**Deploy**: `stow terminal`

### walker
**Target**: ~/.config/walker/
**Contents**: Application launcher config
**Deploy**: `stow walker`

### themes
**Target**: ~/.config/themes/
**Contents**: Centralized theme system
**Deploy**: `stow themes`
**Note**: Contains color schemes and wallpapers

### scripts-local
**Target**: ~/.local/bin/
**Contents**: Custom wrapper scripts
**Deploy**: `stow scripts-local`
**Note**: These replace Omarchy commands

### applications
**Target**: ~/.local/share/applications/
**Contents**: Desktop entry files
**Deploy**: `stow applications`

## Deployment

### Full Deployment
```bash
cd ~/dotfiles
stow shell hyprland waybar terminal walker themes scripts-local applications
```

### Selective Deployment
```bash
# Just shell configs
stow shell

# Just Hyprland
stow hyprland

# Just theme
stow themes
```

### Remove (Unstow)
```bash
stow -D hyprland
```

## File Locations After Deployment

| Stow Package | Files Deploy To |
|--------------|-----------------|
| shell | ~/.bashrc, ~/.vimrc |
| hyprland | ~/.config/hypr/* |
| waybar | ~/.config/waybar/* |
| terminal | ~/.config/alacritty/, ~/.config/starship.toml |
| walker | ~/.config/walker/* |
| themes | ~/.config/themes/main-theme/* |
| scripts-local | ~/.local/bin/* |
| applications | ~/.local/share/applications/* |

## Installation Scripts

### Common Functions (scripts/common.sh)
- `log_info()` - Blue info message
- `log_success()` - Green success message
- `log_warning()` - Yellow warning
- `log_error()` - Red error
- `is_installed()` - Check if pacman package installed
- `command_exists()` - Check if command in PATH
- `install_packages()` - Smart package installation with checking
- `ask_yes_no()` - Interactive yes/no prompt

### Package Scripts
Each script in `scripts/packages/` can be:
1. Sourced by master installer
2. Run independently: `bash scripts/packages/core.sh`

## Key Differences from Original

### Before (Manual Symlinks)
- Single install.sh with hardcoded symlink commands
- All configs in flat .config/ directory
- Manual backup logic
- Omarchy dependencies everywhere

### After (Stow-Based)
- Modular stow packages
- Clean separation of concerns
- Reversible with `stow -D`
- Zero Omarchy dependencies

## Advantages

✓ **Modularity**: Install only what you need
✓ **Reversibility**: `stow -D` to remove
✓ **Organization**: Each component in its own package
✓ **Clarity**: Directory structure mirrors target location
✓ **Standard**: Uses industry-standard tool (stow)
✓ **Safety**: Stow won't overwrite existing files
