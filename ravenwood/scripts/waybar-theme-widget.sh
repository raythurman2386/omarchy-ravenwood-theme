#!/bin/bash

# Configuration
DAY_THEME="ravenwood-light"
NIGHT_THEME="ravenwood"
TIMER_UNIT="omarchy-dynamic-theme.timer"

# Get current state
CURRENT_THEME_RAW=$(omarchy-theme-current)
CURRENT_THEME=$(echo "$CURRENT_THEME_RAW" | tr '[:upper:]' '[:lower:]' | sed 's/ /-/g')
TIMER_ACTIVE=$(systemctl --user is-active --quiet "$TIMER_UNIT" && echo "true" || echo "false")

case "$1" in
    "toggle-theme")
        if [ "$CURRENT_THEME" == "$DAY_THEME" ]; then
            TARGET_THEME="$NIGHT_THEME"
            MODE="Night"
        else
            TARGET_THEME="$DAY_THEME"
            MODE="Day"
        fi
        
        # Disable timer when manually toggled
        if [ "$TIMER_ACTIVE" == "true" ]; then
            systemctl --user disable --now "$TIMER_UNIT"
            notify-send "Dynamic Theme" "Timer disabled. Switched to $TARGET_THEME ($MODE mode)"
        else
            notify-send "Dynamic Theme" "Switched to $TARGET_THEME ($MODE mode)"
        fi
        
        omarchy-theme-set "$TARGET_THEME"
        
        # Trigger an immediate Waybar widget update (signal 9)
        pkill -RTMIN+9 waybar
        ;;
        
    "toggle-timer")
        if [ "$TIMER_ACTIVE" == "true" ]; then
            systemctl --user disable --now "$TIMER_UNIT"
            notify-send "Dynamic Theme" "Auto-switching disabled"
        else
            systemctl --user enable --now "$TIMER_UNIT"
            notify-send "Dynamic Theme" "Auto-switching enabled"
            
            # Run the script immediately to ensure current theme matches time
            ~/.config/omarchy/themes/ravenwood/scripts/dynamic-theme.sh
        fi
        
        # Trigger an immediate Waybar widget update (signal 9)
        pkill -RTMIN+9 waybar
        ;;
        
    "status"|*)
        if [ "$CURRENT_THEME" == "$DAY_THEME" ]; then
            ICON="󰖨"
            THEME_NAME="Day Mode"
        elif [ "$CURRENT_THEME" == "$NIGHT_THEME" ]; then
            ICON="󰖔"
            THEME_NAME="Night Mode"
        else
            # Not using managed theme
            ICON="󰖔" # default to moon if neither
            THEME_NAME="Unmanaged Theme"
        fi
        
        if [ "$TIMER_ACTIVE" == "true" ]; then
            STATUS_ICON="   󰥔"
            TOOLTIP_STATUS="Auto-switching Enabled"
            CLASS="auto"
        else
            STATUS_ICON=""
            TOOLTIP_STATUS="Auto-switching Disabled"
            CLASS="manual"
        fi
        
        # Output JSON format for Waybar (must be a single line)
        echo "{\"text\": \"${ICON}${STATUS_ICON}\", \"tooltip\": \"${THEME_NAME}\\n${TOOLTIP_STATUS}\\n\\nLeft-Click: Toggle Theme & Disable Auto\\nRight-Click: Toggle Auto-switch\", \"class\": \"${CLASS}\"}"
        ;;
esac
