# CLAUDE.md - Arch + Hyprland Dotfiles

## Overview
Backend developer's vanilla Arch Linux + Hyprland dotfiles. Self-contained, modular configuration with centralized theming. No distribution-specific dependencies (migrating from Omarchy). Uses stow for deployment.

## Architecture Principles
- **Modular configs**: Split files for maintainability (Hyprland: bindings/monitors/looknfeel)
- **Centralized theming**: Single theme directory with per-app configs
- **Explicit over implicit**: No magic sourcing, version-controlled everything
- **Developer-first**: Git workflow, Docker shortcuts, terminal-centric tools

## Core Stack

### Hyprland (Window Manager)
- **Main**: `~/.config/hypr/hyprland.conf` - Sources modular configs
- **Bindings**: `~/.config/hypr/bindings.conf` - Super+Shift+Letter pattern for apps
- **Monitors**: `~/.config/hypr/monitors.conf` - Multi-monitor layouts (4-monitor setup)
- **Look & Feel**: `~/.config/hypr/looknfeel.conf` - Gaps (2px), rounded corners (11px), blur effects

### Waybar (Status Bar)
- **Config**: `~/.config/waybar/config.jsonc` - Extensive system monitoring modules
- **Style**: `~/.config/waybar/style.css` - Frosted glass aesthetic
- **Scripts**: `~/.config/waybar/scripts/` - ipaddr.sh (network info), cava.sh (audio viz)
- **Modules**: CPU, memory, disk, load, uptime, network, battery, media controls, system tray

### Application Launcher
- **Walker**: `~/.config/walker/config.toml` - Desktop apps, files, websearch, calculator, clipboard, symbols

### Terminal Stack
- **Alacritty**: `~/.config/alacritty/alacritty.toml` - CaskaydiaMono Nerd Font, custom padding
- **Starship**: `~/.config/starship.toml` - Cross-shell prompt with language/tool detection
- **Bash**: `~/.bashrc` - Git aliases, Docker shortcuts, tree visualization, PATH extension

### Theme System
Target location: `~/.config/themes/main-theme/`
- Per-app configs: alacritty, waybar, hyprland, walker, mako, btop, kitty, ghostty
- GTK overrides, wallpapers, color schemes
- Single source of truth for visual consistency

## Key Scripts

### Installation & Deployment
- **Target**: Stow-based deployment (replacing current install.sh)
- **Package management**: pacman for core packages (hyprland, waybar, walker, alacritty, starship, docker, lazydocker, lazygit, vim, tree, obsidian)

### User Scripts (~/.local/bin/)
- Audio/JACK integration helpers (if needed for Sonic Pi)
- Custom workflow automation
- System utilities

## Keybinding Philosophy

### Application Bindings (Super+Shift+Letter)
Quick access to frequently-used applications. Examples:
- Web apps via browser (Claude, ChatGPT, Calendar, Email)
- Terminal tools (btop, lazydocker, lazygit)
- Development environment

### Reference Table
See `~/.config/hypr/bindings.conf` for complete mappings.

## Customization Patterns

### Adding/Modifying Keybindings
Edit `~/.config/hypr/bindings.conf`:
```conf
bind = SUPER SHIFT, X, exec, your-command-here
```
Reload: `hyprctl reload`

### Multi-Monitor Setup
Edit `~/.config/hypr/monitors.conf`:
```conf
monitor = HDMI-A-1, 1920x1080@60, 0x0, 1
monitor = eDP-1, 1920x1080@60, 0x1080, 1
```
Test without logout: `hyprctl reload`

### Theme Modification
1. Edit color schemes in `~/.config/themes/main-theme/`
2. Update per-app configs (waybar/style.css, hyprland colors, etc.)
3. Reload: `hyprctl reload` (Hyprland), `killall waybar && waybar &` (Waybar)

### Extending Waybar Modules
1. Add module config to `~/.config/waybar/config.jsonc`
2. Style in `~/.config/waybar/style.css`
3. Create script in `~/.config/waybar/scripts/` if needed
4. Reload: `killall waybar && waybar &`

## Development Workflow

### Testing Config Changes
- **Hyprland**: Edit configs → `hyprctl reload` (or Super+Shift+R if bound)
- **Waybar**: Edit configs → `killall waybar && waybar &`
- **Terminal**: Source `~/.bashrc` or reopen terminal
- **Test in isolation**: Use `hyprland -c /path/to/test/config` in nested session

### Git Workflow
- `.bashrc` aliases: `gg` (lazygit), `gita` (git add .), `gitc` (git commit), `gitp` (git push)
- Commit atomically: one feature/fix per commit
- Test before committing: ensure configs don't break Hyprland startup

### Reloading Without Logout
- Hyprland: `hyprctl reload`
- Waybar: `killall waybar && waybar &`
- Walker: Automatically picks up config changes
- Avoid full logout unless testing session init

## Directory Structure
```
~/.config/
├── hypr/              # Hyprland configs (modular)
├── waybar/            # Status bar + scripts
├── walker/            # App launcher
├── alacritty/         # Terminal emulator
├── starship.toml      # Shell prompt
├── themes/            # Centralized theme system
└── ...

~/.local/bin/          # User scripts
~/.bashrc              # Bash config + aliases
~/.vimrc               # Vim config
```

## Important Paths
- Hyprland main config: `~/.config/hypr/hyprland.conf`
- Waybar config: `~/.config/waybar/config.jsonc`
- Theme directory: `~/.config/themes/main-theme/`
- User scripts: `~/.local/bin/`
- Bash aliases: `~/.bashrc`

## Migration Notes
Rebuilding from Omarchy-based setup. Preserving:
- Modular Hyprland config pattern
- Waybar system monitoring setup
- Custom theme system
- Application workflow & keybindings

Removing Omarchy-specific dependencies and overlay patterns.
