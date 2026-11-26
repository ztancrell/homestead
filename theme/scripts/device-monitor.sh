#!/bin/bash

SOUND_DIR="/usr/share/homestead/sounds"
AUDIO_ADDED="$SOUND_DIR/device-added.oga"
AUDIO_REMOVED="$SOUND_DIR/device-removed.oga"
# Per-user state dir: a shared /tmp file could be planted by another user, and its content
# ends up in $(( )), where bash runs command substitutions such as a[$(cmd)].
STATE_DIR="${XDG_RUNTIME_DIR:-$HOME/.cache/homestead}"
mkdir -p -m 700 "$STATE_DIR"
COOLDOWN_FILE="$STATE_DIR/device-monitor-cooldown"
COOLDOWN_SECONDS=3

play_sound() {
    local sound_file="$1"

    if [ -f "$COOLDOWN_FILE" ]; then
        last_play=$(cat "$COOLDOWN_FILE" 2>/dev/null)
        # Only a plain number reaches the arithmetic below
        [[ "$last_play" =~ ^[0-9]+$ ]] || last_play=0
        now=$(date +%s)
        if [ $((now - last_play)) -lt $COOLDOWN_SECONDS ]; then
            return
        fi
    fi

    date +%s > "$COOLDOWN_FILE"
    paplay "$sound_file" &
}

udevadm monitor --udev --subsystem-match=usb --subsystem-match=block | while read -r line; do
    if [[ "$line" == *"["* ]]; then
        if [[ "$line" == *"/usb"[0-9]" "* ]] || [[ "$line" == *"/usb"[0-9]"/"*"/usb"[0-9]"-"[0-9]" "* && "$line" != *"-"[0-9]"."* ]]; then
            continue
        fi

        if [[ "$line" == *" add "* ]]; then
            play_sound "$AUDIO_ADDED"
        elif [[ "$line" == *" remove "* ]]; then
            play_sound "$AUDIO_REMOVED"
        fi
    fi
done
