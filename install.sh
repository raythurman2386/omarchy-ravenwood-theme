#!/bin/bash
set -e

THEMES_DIR="$HOME/.config/omarchy/themes"

install_theme() {
    local theme_name="$1"
    local source_dir="$(dirname "$0")/$theme_name"
    local dest_dir="$THEMES_DIR/$theme_name"

    echo "Installing $theme_name theme to $dest_dir..."

    if [ ! -d "$source_dir" ]; then
        echo "Error: Source directory '$source_dir' not found. Are you running this from the repo root?"
        return 1
    fi

    # Ensure the destination directory exists
    mkdir -p "$dest_dir"

    # Copy contents (using -u to only update newer files if supported, or just cp)
    cp -ru "$source_dir"/* "$dest_dir/"

    # Cleanup old backgrounds and setup scheduling for ravenwood (dark)
    if [ "$theme_name" == "ravenwood" ]; then
        # Setup dynamic theme service
        if [ -d "$dest_dir/scripts" ]; then
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
            
            # Check if timer is already enabled/active
            if ! systemctl --user is-active --quiet omarchy-dynamic-theme.timer; then
                echo "Dynamic theme switcher is not currently active."
                read -p "Do you want to enable the dynamic theme switcher (auto switch Day/Night)? (y/N) " -n 1 -r
                echo
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    systemctl --user enable --now omarchy-dynamic-theme.timer
                    echo "Dynamic theme switcher enabled!"
                    "$dest_dir/scripts/dynamic-theme.sh"
                fi
            else
                if [ "$changed" == true ]; then
                    systemctl --user restart omarchy-dynamic-theme.timer
                    echo "Dynamic theme switcher updated and restarted."
                else
                    echo "Dynamic theme switcher is already active and up to date."
                fi
            fi
        fi
    fi

    echo "$theme_name installed successfully!"
}

# Install both themes
install_theme "ravenwood"
install_theme "ravenwood-light"

echo "---------------------------------------------------"
echo "Installation complete!"
echo "You can apply themes manually with:"
echo "  omarchy-theme-set ravenwood"
echo "  omarchy-theme-set ravenwood-light"
