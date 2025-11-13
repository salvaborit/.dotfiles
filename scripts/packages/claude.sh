#!/usr/bin/env bash

# Claude Code CLI installation

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common.sh"

install_claude_code() {
    log_info "Checking for Claude Code..."
    echo ""

    # Check if claude is in PATH or in common installation locations
    if command_exists claude || [ -f "$HOME/.local/bin/claude" ] || [ -f "/usr/local/bin/claude" ]; then
        log_success "Claude Code is already installed"
        return 0
    fi

    log_info "Downloading and installing Claude Code..."
    if curl -fsSL https://claude.ai/install.sh | bash; then
        log_success "Claude Code installed successfully"
        log_info "You may need to restart your shell or source your profile"
        return 0
    else
        log_error "Claude Code installation failed"
        return 1
    fi
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_claude_code
fi
