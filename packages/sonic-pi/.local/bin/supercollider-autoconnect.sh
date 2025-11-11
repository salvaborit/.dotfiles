#!/usr/bin/env bash
# Auto-connect SuperCollider JACK ports to system audio outputs
# This script waits for SuperCollider to initialize, then connects its outputs

# Wait for SuperCollider JACK client to appear (max 10 seconds)
for i in {1..20}; do
    if pw-jack jack_lsp 2>/dev/null | grep -q "^SuperCollider:out_1$"; then
        break
    fi
    sleep 0.5
done

# Get the actual speaker device name (it varies by hardware)
SPEAKER_L=$(pw-jack jack_lsp 2>/dev/null | grep "Speaker:playback_FL" | head -1)
SPEAKER_R=$(pw-jack jack_lsp 2>/dev/null | grep "Speaker:playback_FR" | head -1)

# Connect if we found the speaker ports
if [ -n "$SPEAKER_L" ] && [ -n "$SPEAKER_R" ]; then
    pw-jack jack_connect "SuperCollider:out_1" "$SPEAKER_L" 2>/dev/null
    pw-jack jack_connect "SuperCollider:out_2" "$SPEAKER_R" 2>/dev/null
    exit 0
fi

# Fallback: try to connect to any available playback device
PLAYBACK_L=$(pw-jack jack_lsp 2>/dev/null | grep ":playback_FL" | head -1)
PLAYBACK_R=$(pw-jack jack_lsp 2>/dev/null | grep ":playback_FR" | head -1)

if [ -n "$PLAYBACK_L" ] && [ -n "$PLAYBACK_R" ]; then
    pw-jack jack_connect "SuperCollider:out_1" "$PLAYBACK_L" 2>/dev/null
    pw-jack jack_connect "SuperCollider:out_2" "$PLAYBACK_R" 2>/dev/null
fi
