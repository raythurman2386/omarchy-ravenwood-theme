#!/bin/bash

# Configuration
DAY_THEME="ravenwood-light"
NIGHT_THEME="ravenwood"
DAY_START=7  # 7 AM
NIGHT_START=19 # 7 PM

# Get current hour (0-23)
CURRENT_HOUR=$(date +%H)

# Determine target theme
if (( CURRENT_HOUR >= DAY_START && CURRENT_HOUR < NIGHT_START )); then
    TARGET_THEME="$DAY_THEME"
    MODE="Day"
else
    TARGET_THEME="$NIGHT_THEME"
    MODE="Night"
fi

# Get current theme and normalize it (e.g., "Ravenwood Light" -> "ravenwood-light")
# omarchy-theme-current returns "Ravenwood Light", but we need "ravenwood-light" for commands
CURRENT_THEME_RAW=$(omarchy-theme-current)
CURRENT_THEME=$(echo "$CURRENT_THEME_RAW" | tr '[:upper:]' '[:lower:]' | sed 's/ /-/g')

# Only proceed if the current theme is one of our managed themes
if [[ "$CURRENT_THEME" != "$DAY_THEME" && "$CURRENT_THEME" != "$NIGHT_THEME" ]]; then
    # User is on a different theme (e.g. Tokyonight), don't disturb them
    exit 0
fi

# Only switch if needed to avoid restarting things unnecessarily
if [[ "$CURRENT_THEME" != "$TARGET_THEME" ]]; then
    echo "Time is $(date +%H:%M). Switching to $MODE theme: $TARGET_THEME"
    # Use the full path or ensure it's in PATH. Omarchy commands are usually in PATH.
    omarchy-theme-set "$TARGET_THEME"
    
    # Send notification
    notify-send "Dynamic Theme" "Switched to $TARGET_THEME ($MODE mode)"
else
    echo "Already on $TARGET_THEME ($MODE mode). No change needed."
fi
