#!/bin/bash
set -e

# Check for required dependencies
if ! command -v rsync &>/dev/null; then
    echo "Error: rsync is required but not installed"
    exit 1
fi

# Get absolute path to the directory containing this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEMES_DIR="$HOME/.config/omarchy/themes"

install_theme() {
    local theme_name="$1"
    local source_dir="$SCRIPT_DIR/$theme_name"
    local dest_dir="$THEMES_DIR/$theme_name"

    echo "Installing $theme_name theme to $dest_dir..."

    if [[ ! -d "$source_dir" ]]; then
        echo "Error: Source directory '$source_dir' not found. Are you running this from the repo root?"
        return 1
    fi

    # Ensure the destination directory exists
    mkdir -p "$dest_dir"

    # Use rsync to ensure an exact 1:1 copy (removes orphaned files, includes dotfiles)
    rsync -a --delete "$source_dir/" "$dest_dir/"

    # Setup scheduling for ravenwood (dark)
    if [[ "$theme_name" == "ravenwood" ]]; then
        if [[ -d "$dest_dir/scripts" ]]; then
            mkdir -p ~/.config/systemd/user
            
            # Only copy and reload if files differ
            local changed=false
            if ! diff -q "$dest_dir/scripts/omarchy-dynamic-theme.service" ~/.config/systemd/user/omarchy-dynamic-theme.service >/dev/null 2>&1 || \
               ! diff -q "$dest_dir/scripts/omarchy-dynamic-theme.timer" ~/.config/systemd/user/omarchy-dynamic-theme.timer >/dev/null 2>&1; then
                echo "Updating systemd units..."
                cp "$dest_dir/scripts/omarchy-dynamic-theme.service" ~/.config/systemd/user/
                cp "$dest_dir/scripts/omarchy-dynamic-theme.timer" ~/.config/systemd/user/
                systemctl --user daemon-reload
                changed=true
            fi
            
            # Make scripts executable
            chmod +x "$dest_dir/scripts/"*.sh || true
            
            # Check if user has explicitly disabled or enabled the timer
            local is_enabled
            is_enabled=$(systemctl --user is-enabled omarchy-dynamic-theme.timer 2>/dev/null || echo "disabled")

            if [[ "$is_enabled" == "disabled" || "$is_enabled" == "static" || "$is_enabled" == "masked" ]]; then
                echo "Dynamic theme switcher is currently disabled."
                read -p "Do you want to enable the dynamic theme switcher (auto switch Day/Night)? (y/N) " -n 1 -r
                echo
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    systemctl --user enable --now omarchy-dynamic-theme.timer
                    echo "Dynamic theme switcher enabled!"
                    "$dest_dir/scripts/dynamic-theme.sh"
                fi
            else
                if [[ "$changed" == "true" ]]; then
                    systemctl --user restart omarchy-dynamic-theme.timer
                    echo "Dynamic theme switcher updated and restarted."
                else
                    echo "Dynamic theme switcher is already enabled and up to date."
                fi
            fi
        fi
    fi

    echo "$theme_name installed successfully!"
}

# Install both themes
install_theme "ravenwood"
install_theme "ravenwood-light"

# Install the theme-set hook that syncs the Hermes TUI skin to the active theme
HOOK_SRC="$SCRIPT_DIR/ravenwood/scripts/omarchy-theme-set-hermes-skin.hook"
HOOK_DEST="$HOME/.config/omarchy/hooks/theme-set.d/omarchy-theme-set-hermes-skin"
if [[ -f "$HOOK_SRC" ]]; then
    mkdir -p "$(dirname "$HOOK_DEST")"
    cp "$HOOK_SRC" "$HOOK_DEST"
    chmod +x "$HOOK_DEST"
    echo "Hermes skin-sync hook installed to $HOOK_DEST"
fi

# Install the Ravenwood light Hermes skin (used by the hook for light mode)
HERMES_SKIN_SRC="$SCRIPT_DIR/ravenwood/scripts/hermes-skins/ravenwood-light.yaml"
HERMES_SKIN_DEST="$HOME/.hermes/skins/ravenwood-light.yaml"
if [[ -f "$HERMES_SKIN_SRC" ]]; then
    mkdir -p "$(dirname "$HERMES_SKIN_DEST")"
    cp "$HERMES_SKIN_SRC" "$HERMES_SKIN_DEST"
    echo "Ravenwood light Hermes skin installed to $HERMES_SKIN_DEST"
fi

# Install VS Code static themes (skip if the extension is already installed)
VSCODE_EXT_DIRS=(
    "$HOME/.vscode/extensions"
    "$HOME/.vscode-oss/extensions"
    "$HOME/.vscode-server/extensions"
)
VSCODE_EXT_INSTALLED=false
for ext_dir in "${VSCODE_EXT_DIRS[@]}"; do
    if ls "$ext_dir"/raymondthurman.ravenwood* >/dev/null 2>&1; then
        VSCODE_EXT_INSTALLED=true
        break
    fi
done

if [[ "$VSCODE_EXT_INSTALLED" == "true" ]]; then
    echo "VS Code extension 'Ravenwood' detected — skipping static theme install."
else
    echo "Installing VS Code static themes..."
    VSCODE_THEMES_DIR="$HOME/.config/omarchy/themes/vscode"
    mkdir -p "$VSCODE_THEMES_DIR"
    cp "$SCRIPT_DIR/vscode/ravenwood-dark.json" "$VSCODE_THEMES_DIR/"
    cp "$SCRIPT_DIR/vscode/ravenwood-light.json" "$VSCODE_THEMES_DIR/"
    echo "VS Code themes installed to $VSCODE_THEMES_DIR/"
fi

# Install Zed theme
ZED_THEMES_DIR="$HOME/.config/zed/themes"
if command -v zed &>/dev/null; then
    mkdir -p "$ZED_THEMES_DIR"
    cp "$SCRIPT_DIR/zed/ravenwood.json" "$ZED_THEMES_DIR/ravenwood.json"
    echo "Zed theme installed to $ZED_THEMES_DIR/ravenwood.json"
fi

echo "---------------------------------------------------"
echo "Installation complete!"
echo "You can apply themes manually with:"
echo "  omarchy-theme-set ravenwood"
echo "  omarchy-theme-set ravenwood-light"
echo "  VS Code: Open Command Palette > Preferences: Color Theme > Ravenwood Dark / Light"
echo "  Zed: Select 'Ravenwood Dark' or 'Ravenwood Light' in theme selector"
