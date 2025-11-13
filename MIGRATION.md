# Migration Guide: Omarchy to Vanilla Arch + Hyprland

This document tracks the migration from Omarchy-based dotfiles to vanilla Arch + Hyprland.

## What Changed

### Architecture
- **Before**: Omarchy distribution overlay with custom commands and themes
- **After**: Pure Arch Linux with vanilla Hyprland and custom wrapper scripts

### File Structure
- **Before**: Manual symlink installer with scattered configs
- **After**: GNU stow-based deployment with modular packages

### Installation
- **Before**: Single monolithic install.sh
- **After**: Modular per-program install scripts

## Omarchy Dependencies Removed

### Commands Replaced

| Omarchy Command | Replacement |
|----------------|-------------|
| `omarchy-launch-browser` | `launch-browser` |
| `omarchy-launch-or-focus` | `launch-or-focus` |
| `omarchy-launch-webapp` | `launch-webapp` |
| `omarchy-launch-or-focus-webapp` | `launch-or-focus-webapp` |
| `omarchy-menu` | `walker` |
| `omarchy-launch-wifi` | `nmtui` |
| `uwsm app --` | Direct command execution |

### Configs Updated

**Hyprland** (`~/.config/hypr/hyprland.conf`):
- Removed: All `source = ~/.local/share/omarchy/...` lines
- Added: Direct sources for custom configs
- Created: Missing configs (input.conf, envs.conf, autostart.conf)

**Bindings** (`~/.config/hypr/bindings.conf`):
- Replaced: All omarchy-* commands with custom wrappers
- Updated: Terminal variable from `uwsm app -- $TERMINAL` to `alacritty`
- Simplified: Direct app launches instead of uwsm wrapper

**Waybar** (`~/.config/waybar/config.jsonc`):
- Removed: `custom/omarchy` module
- Removed: `custom/update` module (Omarchy updates)
- Removed: `custom/screenrecording-indicator`
- Updated: Click handlers to use standard tools

**Bash** (`~/.bashrc`):
- Removed: `source ~/.local/share/omarchy/default/bash/rc`
- Kept: All custom aliases and functions

### Theme Migration

**Before**: `.config/omarchy/themes/omarchy-sba-00-theme/`
**After**: `.config/themes/main-theme/`

**Migrated**:
- Wallpapers moved to theme directory
- Minimal color scheme extracted
- Per-app themes simplified

**Not Migrated** (omitted for vanilla setup):
- Omarchy-specific CSS overrides
- Neovim/VSCode themes (optional)
- Warp terminal config (not used)
- Icon themes (Omarchy-specific)

## Custom Wrapper Scripts

Created in `~/.local/bin/` to replace Omarchy functionality:

### launch-or-focus
Smart window management - launches app if not running, focuses if it is.
Uses `hyprctl clients` and `jq` to find windows.

### launch-browser
Detects default browser via xdg-settings, handles private/incognito mode.

### launch-webapp
Opens URL in default browser, ensures https:// protocol.

### launch-or-focus-webapp
Combines launch-webapp with window focus logic.

## Hyprland Configs Created

### input.conf
Keyboard and mouse settings extracted from Omarchy defaults:
- Layout: US
- Follow mouse enabled
- Natural scroll enabled (changed from Omarchy default)

### envs.conf
Environment variables for Wayland:
- Cursor size
- Force Wayland for Qt/GTK apps
- Screen sharing support
- XWayland scaling

### autostart.conf
Startup applications:
- Waybar, mako, walker
- Polkit agent
- Environment import for systemd

## Package Changes

### Added to Install
- `hyprland` (was missing!)
- `walker` (was missing!)
- `grim`, `slurp` (screenshots)
- `wl-clipboard` (clipboard)
- `polkit-kde-agent` (authentication)
- `chromium` (default browser)
- `less` (pager)

### Kept
- alacritty, starship, waybar
- docker, lazydocker, lazygit
- obsidian, nautilus
- vim, tree, unzip
- sonic-pi, supercollider (optional)

### Audio Stack
Now optional during install - can skip if not needed.

## Stow Packages

New modular structure:
1. `shell` - .bashrc, .vimrc
2. `hyprland` - Window manager configs
3. `waybar` - Status bar
4. `terminal` - Alacritty + Starship
5. `walker` - App launcher
6. `themes` - Centralized theme
7. `scripts-local` - Custom wrapper scripts
8. `applications` - Desktop entries

## Testing Checklist

After migration, verify:
- [ ] Hyprland starts successfully
- [ ] Waybar displays correctly
- [ ] Keybindings work (Super+Shift+B for browser, etc)
- [ ] Walker launches (Super+Space)
- [ ] Terminal opens in CWD (Super+Return)
- [ ] launch-or-focus works (Super+Shift+O for Obsidian)
- [ ] Web apps launch (Super+Shift+A for Claude)
- [ ] Docker starts (`sudo systemctl status docker`)
- [ ] Theme applies correctly
- [ ] Custom scripts are in PATH

## Rollback

If migration fails, old configs are in:
- `/home/sba/dotfiles/.config/` (originals)
- Omarchy source: `/home/sba/omarchy-sba/` (reference)

To rollback:
1. `stow -D <package>` to remove stow links
2. Restore original configs from backup
3. Re-source Omarchy: `source ~/.local/share/omarchy/default/bash/rc`

## Benefits of Migration

✓ **Simplicity**: No hidden dependencies or magic sourcing
✓ **Portability**: Works on any Arch system with Hyprland
✓ **Transparency**: All configs explicit and version-controlled
✓ **Maintainability**: Modular structure easy to understand
✓ **Performance**: No unnecessary overlay layers
✓ **Control**: Direct Hyprland configuration

## Next Steps

1. Test thoroughly on current system
2. Update CLAUDE.md with new structure
3. Remove old configs after confirming migration
4. Commit to git with "Migrate from Omarchy to vanilla Arch+Hyprland"
5. Test clean install on VM or spare machine
