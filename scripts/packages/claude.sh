#!/usr/bin/env bash

# Claude Code CLI installation

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common.sh"

install_claude_code() {
    log_info "Checking for Claude Code..."
    echo ""

    # Check if claude npm package is installed
    local npm_claude_installed=false
    if [ -f "/usr/bin/claude" ] || [ -f "/usr/local/bin/claude" ] || command_exists claude; then
        npm_claude_installed=true
    fi

    # Check if wrapper script is deployed via stow
    local wrapper_deployed=false
    if [ -L "$HOME/.local/bin/claude" ] && [ -f "$HOME/.local/bin/claude" ]; then
        wrapper_deployed=true
    fi

    if [ "$npm_claude_installed" = true ] && [ "$wrapper_deployed" = true ]; then
        log_success "Claude Code is already installed and wrapper is deployed"
        return 0
    fi

    # Install npm package if needed
    if [ "$npm_claude_installed" = false ]; then
        log_info "Downloading and installing Claude Code..."
        if curl -fsSL https://claude.ai/install.sh | bash; then
            log_success "Claude Code installed successfully"
        else
            log_error "Claude Code installation failed"
            return 1
        fi
    fi

    # Note: The wrapper script at scripts-local/.local/bin/claude
    # will be deployed automatically by stow (scripts-local package)
    log_info "Claude Code wrapper will be deployed via stow (scripts-local)"

    return 0
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    start_timer "$(basename "$0")"
    if install_claude_code; then
        end_timer "success"
    else
        end_timer "failed"
    fi
fi
