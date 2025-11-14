# Arch + Hyprland Dotfiles

Clean, modular dotfiles for Arch Linux with Hyprland window manager. Designed for developers with a focus on simplicity and maintainability.

## Features

- **Modular Configuration**: Separate files for different concerns (monitors, bindings, appearance)
- **GNU Stow Deployment**: Simple, reversible symlink management
- **Modular Installation**: Each program has its own install script
- **Custom Wrapper Scripts**: Smart window management (launch-or-focus functionality)
- **Centralized Theming**: Single source of truth for visual consistency
- **No External Dependencies**: Pure Arch + Hyprland, no distribution overlays

## Quick Start

```bash
# Clone the repository
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles

# Run installation
./install-new.sh
```

The installer will:
1. Install all required packages via pacman
2. Deploy configurations using GNU stow
3. Set up custom wrapper scripts
4. Configure the minimal theme

## Structure

```
dotfiles/
├── shell/              # Shell configs (.bashrc, .vimrc)
├── hyprland/           # Hyprland window manager
├── waybar/             # Status bar
├── terminal/           # Alacritty + Starship
├── walker/             # Application launcher
├── themes/             # Centralized theme system
├── scripts-local/      # Custom wrapper scripts
├── applications/       # Desktop entries
└── scripts/            # Installation scripts
    ├── common.sh       # Shared functions
    └── packages/       # Per-program installers
```

## Core Stack

### Window Manager & UI
- **Hyprland** - Wayland compositor
- **Waybar** - Status bar with system monitoring
- **Walker** - Application launcher
- **Mako** - Notification daemon

### Terminal & Shell
- **Alacritty** - GPU-accelerated terminal
- **Starship** - Cross-shell prompt
- **Bash** - Shell with custom aliases

### Development Tools
- **Docker** + lazydocker
- **Git** + lazygit
- **Vim** - Text editor

### Applications
- **Chromium** - Web browser
- **Obsidian** - Note taking
- **Nautilus** - File manager

## Configuration

### Hyprland

All Hyprland configs are in `~/.config/hypr/`:
- `hyprland.conf` - Main config (sources all others)
- `bindings.conf` - Keybindings (Super+Shift+Letter pattern)
- `monitors.conf` - Multi-monitor setup
- `looknfeel.conf` - Appearance (gaps, rounding, blur)
- `input.conf` - Keyboard and mouse
- `envs.conf` - Environment variables
- `autostart.conf` - Startup applications

**Reload config**: `hyprctl reload`

### Keybindings

All application bindings use Super+Shift+Letter:
- `Super+Return` - Terminal (in current directory)
- `Super+Shift+F` - File manager
- `Super+Shift+B` - Browser
- `Super+Shift+O` - Obsidian
- `Super+Shift+T` - System monitor (btop)
- `Super+Shift+D` - Docker manager
- `Super+Shift+A` - Claude AI
- `Super+Space` - App launcher

See `~/.config/hypr/bindings.conf` for complete list.

### Custom Wrapper Scripts

Located in `~/.local/bin/`:
- `launch-or-focus` - Launch app or focus if running
- `launch-browser` - Smart browser launcher
- `launch-webapp` - Open URL in browser
- `launch-or-focus-webapp` - Focus or launch web app

These replace Omarchy-specific commands with vanilla Hyprland equivalents.

### Waybar

Configuration: `~/.config/waybar/config.jsonc`
Styling: `~/.config/waybar/style.css`
Scripts: `~/.config/waybar/scripts/`

**Reload**: `killall waybar && waybar &`

### Theme System

Centralized theme in `~/.config/themes/main-theme/`:
- `colors.conf` - Central color definitions
- `wallpapers/` - Background images
- Per-app theme overrides

To change wallpaper:
1. Add image to `~/.config/themes/main-theme/wallpapers/`
2. Update `~/.config/hypr/autostart.conf`

## Installation Scripts

Modular package installers in `scripts/packages/`:
- `core.sh` - Base system (git, vim, etc)
- `hyprland.sh` - Window manager stack
- `terminal.sh` - Terminal tools
- `development.sh` - Dev tools (docker, lazygit)
- `applications.sh` - User applications
- `fonts.sh` - Nerd fonts
- `audio.sh` - Sonic Pi (optional)
- `claude.sh` - Claude Code CLI

Run individually: `bash scripts/packages/core.sh`

## Stow Management

Deploy all configs:
```bash
stow shell hyprland waybar terminal walker themes scripts-local applications
```

Deploy specific package:
```bash
stow hyprland
```

Remove (unstow) package:
```bash
stow -D hyprland
```

## Customization

### Adding New Keybinding

Edit `~/.config/hypr/bindings.conf`:
```conf
bindd = SUPER SHIFT, X, Description, exec, your-command
```

Reload: `hyprctl reload`

### Multi-Monitor Setup

Edit `~/.config/hypr/monitors.conf`:
```conf
monitor = HDMI-A-1, 1920x1080@60, 0x0, 1
monitor = eDP-1, 1920x1080@60, 0x1080, 1
```

Reload: `hyprctl reload`

### Custom Aliases

Add to `~/.bashrc`:
```bash
alias mycommand='...'
```

Reload: `source ~/.bashrc`

## Migration from Omarchy

This setup replaces all Omarchy dependencies:
- No more `omarchy-launch-*` commands (replaced with custom wrappers)
- No more `omarchy-menu` (using walker directly)
- No more Omarchy theme overlays (minimal theme instead)
- Direct Hyprland configuration (no Omarchy defaults)

Old configs backed up during migration for reference.

## Troubleshooting

### Hyprland won't start
- Check logs: `journalctl -u display-manager -e`
- Verify configs: `hyprland -c ~/.config/hypr/hyprland.conf`

### Waybar not showing
- Check if running: `pgrep waybar`
- Restart: `killall waybar && waybar &`
- Check logs: `waybar -l debug`

### Keybindings not working
- Verify custom scripts are executable: `chmod +x ~/.local/bin/*`
- Check script path: `which launch-browser`
- Test manually: `launch-browser`

### Applications not launching
- Verify package installed: `pacman -Q <package>`
- Check executable name: `which <app>`
- Test from terminal first

## Development Workflow

### Git Workflow
Bash aliases:
- `gg` - lazygit
- `gita` - git add .
- `gitc` - git commit -m
- `gitp` - git push

### Testing Config Changes
- Hyprland: `hyprctl reload`
- Waybar: `killall waybar && waybar &`
- Shell: `source ~/.bashrc`

Test in isolation without breaking your session:
```bash
Hyprland -c /path/to/test/config
```

## Contributing

When adding new features:
1. Keep configs modular
2. Use custom wrapper scripts for complex logic
3. Document keybindings in CLAUDE.md
4. Test before committing

## License

MIT License - Feel free to use and modify
