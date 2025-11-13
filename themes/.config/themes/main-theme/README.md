# Main Theme

Minimal theme for Arch + Hyprland setup.

## Structure

- `colors.conf` - Central color scheme definitions
- `alacritty/` - Terminal color scheme
- `waybar/` - Status bar theming
- `hyprland/` - Window manager colors (borders, etc)
- `walker/` - Application launcher theme
- `btop/` - System monitor theme
- `mako/` - Notification theme
- `wallpapers/` - Background images

## Usage

Theme files are meant to be sourced or linked from their respective application configs.

To add a wallpaper:
1. Copy image to `wallpapers/`
2. Update `~/.config/hypr/autostart.conf` to point to the wallpaper

## Customization

Colors are defined in `colors.conf` and can be referenced in app-specific theme files.
