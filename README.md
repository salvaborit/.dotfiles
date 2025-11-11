# dotfiles

Personal dotfiles and system configuration for SBA, organized with GNU Stow.

## Quick Start

```bash
cd ~/dotfiles
./scripts/bootstrap.sh
```

This will install all packages and stow default configurations (bash, vim, alacritty, starship).

## Installation Options

### Full Installation (Recommended)
Install all packages and stow configurations:
```bash
./scripts/bootstrap.sh
```

### Minimal Installation
Install only core utilities and terminal tools:
```bash
./scripts/bootstrap.sh --minimal
```

### Install Packages Only
Install packages without stowing configs:
```bash
./scripts/bootstrap.sh --packages-only
```

### Stow Configs Only
Stow configurations (if packages already installed):
```bash
./scripts/bootstrap.sh --skip-packages
```

## Managing Configurations with Stow

### Stow Default Packages
```bash
./scripts/stow-packages.sh --default
```

### Stow All Packages
```bash
./scripts/stow-packages.sh --all
```

### Stow Specific Packages
```bash
./scripts/stow-packages.sh bash vim alacritty
```

### Unstow Packages
```bash
./scripts/stow-packages.sh --unstow bash
```

### Restow Packages (after changes)
```bash
./scripts/stow-packages.sh --restow hypr waybar
```

### Check Stow Status
```bash
./scripts/stow-packages.sh --status
```

## Directory Structure

```
~/dotfiles/
├── packages/              # Stow packages (configs organized by program)
│   ├── bash/
│   │   └── .bashrc
│   ├── vim/
│   │   └── .vimrc
│   ├── alacritty/
│   │   └── .config/alacritty/
│   ├── starship/
│   │   └── .config/starship.toml
│   ├── hypr/
│   │   └── .config/hypr/
│   ├── waybar/
│   │   └── .config/waybar/
│   ├── walker/
│   │   └── .config/walker/
│   ├── uwsm/
│   │   └── .config/uwsm/
│   ├── omarchy/
│   │   └── .config/omarchy/
│   └── sonic-pi/
│       └── .local/
│           ├── bin/
│           └── share/applications/
├── assets/                # Shared assets
│   ├── backgrounds/
│   ├── fonts/
│   └── ascii-art/
├── scripts/
│   ├── bootstrap.sh       # Main installation script
│   ├── stow-packages.sh   # Stow management script
│   └── install/           # Individual install scripts
│       ├── core-utils.sh
│       ├── terminal.sh
│       ├── docker-tools.sh
│       ├── gui-apps.sh
│       ├── wayland-desktop.sh
│       └── audio.sh
├── optional/              # Optional/OS-specific configurations
│   └── omarchy-sonic-pi-fix.sh
└── README.md
```

## Available Packages (Stow)

| Package | Description | Config Files |
|---------|-------------|--------------|
| bash | Bash shell configuration | .bashrc |
| vim | Vim editor configuration | .vimrc |
| alacritty | Terminal emulator | .config/alacritty/ |
| starship | Cross-shell prompt | .config/starship.toml |
| hypr | Hyprland window manager | .config/hypr/ |
| waybar | Wayland status bar | .config/waybar/ |
| walker | Application launcher | .config/walker/ |
| uwsm | Wayland session manager | .config/uwsm/ |
| omarchy | Omarchy-specific themes | .config/omarchy/ |
| sonic-pi | Sonic Pi scripts & fixes | .local/bin/, .local/share/applications/ |

## Installation Categories

### Core Utilities
**Script:** `scripts/install/core-utils.sh`

- vim - Text editor
- tree - Directory listing
- unzip - Archive extraction
- ufw - Firewall

### Terminal Tools
**Script:** `scripts/install/terminal.sh`

- alacritty - GPU-accelerated terminal emulator
- starship - Cross-shell prompt

### Docker Tools
**Script:** `scripts/install/docker-tools.sh`

- docker - Container platform
- lazydocker - Terminal UI for docker
- lazygit - Terminal UI for git

Automatically configures Docker service and user permissions.

### GUI Applications
**Script:** `scripts/install/gui-apps.sh`

- obsidian - Knowledge management

### Wayland Desktop
**Script:** `scripts/install/wayland-desktop.sh`

- waybar - Status bar for Wayland compositors

### Audio Tools
**Script:** `scripts/install/audio.sh`

- sonic-pi - Live coding music synthesizer
- supercollider - Audio synthesis platform
- jack-example-tools - JACK audio utilities
- sc3-plugins - SuperCollider plugins

## Individual Install Scripts

Each install script is self-contained with its own logic, validations, and error handling:

```bash
# Install specific category
./scripts/install/core-utils.sh
./scripts/install/terminal.sh
./scripts/install/docker-tools.sh
./scripts/install/gui-apps.sh
./scripts/install/wayland-desktop.sh
./scripts/install/audio.sh
```

All scripts:
- Check if packages are already installed
- Validate installation after completion
- Provide clear success/failure messages
- Are idempotent (safe to run multiple times)

## Optional Configurations

### Sonic Pi Audio Fix (Omarchy)

**Automatically applied during bootstrap on Omarchy installations.**

Fixes Sonic Pi audio output on Omarchy by auto-connecting SuperCollider JACK ports to system audio outputs.

#### What It Does
- Detects Omarchy OS using `pacman -Q omarchy-keyring`
- Installs required packages if needed
- Deploys wrapper scripts for automatic JACK port connection
- Makes Sonic Pi work with PipeWire out-of-the-box

#### Manual Installation
```bash
./optional/omarchy-sonic-pi-fix.sh
```

#### Usage After Installation
Launch Sonic Pi from your application menu/launcher, or run:
```bash
~/.local/bin/sonic-pi-with-audio
```

#### Technical Details
- **Problem**: SuperCollider connects to PipeWire's JACK emulation but ports aren't auto-connected
- **Solution**: Wrapper script launches Sonic Pi and automatically connects JACK ports
- **Components**:
  - `supercollider-autoconnect.sh` - Waits for SuperCollider and connects ports
  - `sonic-pi-with-audio` - Wrapper that launches Sonic Pi + autoconnect
  - `sonic-pi.desktop` - Desktop entry override that uses the wrapper

## How Stow Works

GNU Stow creates symlinks from your home directory to the dotfiles repository.

### Example
When you run:
```bash
./scripts/stow-packages.sh bash
```

Stow creates:
```
~/.bashrc -> ~/dotfiles/packages/bash/.bashrc
```

### Benefits
- Keep all configs in one place
- Easy version control with git
- Selective installation per machine
- Automatic backup of existing files
- Easy to unstow and revert

### Backups
Before stowing, existing files are backed up to:
```
~/.dotfiles_backup/
```

## Post-Installation

### Apply Shell Changes
```bash
source ~/.bashrc
```

### Docker Group Membership
After installing Docker tools, log out and back in for group changes to take effect.

### Check What's Stowed
```bash
./scripts/stow-packages.sh --status
```

## Useful Commands

```bash
# Help for bootstrap
./scripts/bootstrap.sh --help

# Help for stow management
./scripts/stow-packages.sh --help

# List available packages
./scripts/stow-packages.sh --list

# Check stow status
./scripts/stow-packages.sh --status

# Stow additional packages
./scripts/stow-packages.sh hypr waybar walker uwsm

# Unstow a package
./scripts/stow-packages.sh --unstow hypr

# Restow after editing
./scripts/stow-packages.sh --restow bash
```

## Adding New Packages

1. Create a new package directory:
   ```bash
   mkdir -p packages/myapp/.config/myapp
   ```

2. Add your config files:
   ```bash
   cp ~/.config/myapp/* packages/myapp/.config/myapp/
   ```

3. Add to available packages in `scripts/stow-packages.sh`:
   ```bash
   AVAILABLE_PACKAGES=(
       ...
       "myapp"
   )
   ```

4. Stow the new package:
   ```bash
   ./scripts/stow-packages.sh myapp
   ```

## Creating New Install Scripts

1. Create a new script in `scripts/install/`:
   ```bash
   touch scripts/install/my-category.sh
   chmod +x scripts/install/my-category.sh
   ```

2. Use the existing scripts as templates (they include package checking, installation, and validation)

3. Add to bootstrap script if it should be part of full installation

## Troubleshooting

### Stow Conflicts
If stow reports conflicts, check what's in the way:
```bash
ls -la ~/.<file>
```

Files are automatically backed up to `~/.dotfiles_backup/`

### Package Not Found
Ensure the package is available in your system's repositories:
```bash
pacman -Ss <package-name>
```

### Validation Failures
Check the specific install script output for details on what failed.

## Requirements

- Arch Linux (or Arch-based distribution)
- GNU Stow (automatically installed by bootstrap)
- Git (for cloning this repository)
- sudo access (for package installation)

## License

Personal configuration files for SBA.
