#!/bin/bash
set -e

THEMES_DIR="$HOME/.config/omarchy/themes"

install_theme() {
    local theme_name="$1"
    local source_dir="$theme_name"
    local dest_dir="$THEMES_DIR/$theme_name"
    local is_dark=false

    if [ "$theme_name" == "ravenwood" ]; then
        is_dark=true
    fi

    echo "Installing $theme_name theme to $dest_dir..."

    if [ ! -d "$source_dir" ]; then
        echo "Error: Source directory '$source_dir' not found. Are you running this from the repo root?"
        return 1
    fi

    # Ensure the destination directory exists
    mkdir -p "$dest_dir"

    # Copy contents
    cp -r "$source_dir"/* "$dest_dir/"

    # Cleanup old backgrounds for ravenwood (dark)
    if [ "$is_dark" == true ]; then
        for old_bg in \
            "1-ravenwood.jpg" "fog_forest_1.png" \
            "1-ravenwood-glow.png" "2-ravenwood-gradient.png" \
            "3-ravenwood-jade-1.jpg" "4-ravenwood-jade-2.jpg" "5-ravenwood-jade-3.jpg" \
            "2-ravenwood-glow.png" "3-ravenwood-gradient.png" \
            "4-ravenwood-jade-1.jpg" "5-ravenwood-jade-2.jpg" "6-ravenwood-jade-3.jpg"; do
            if [ -f "$dest_dir/backgrounds/$old_bg" ]; then
                rm "$dest_dir/backgrounds/$old_bg"
            fi
        done
        
        # Setup dynamic theme service
        # We need absolute paths for systemd files or we copy them
        if [ -d "$dest_dir/scripts" ]; then
            echo "Setting up dynamic theme scheduling..."
            mkdir -p ~/.config/systemd/user
            
            # Use absolute paths for the service file content
            # The service file we wrote has ExecStart=%h/... which is good
            
            cp "$dest_dir/scripts/omarchy-dynamic-theme.service" ~/.config/systemd/user/
            cp "$dest_dir/scripts/omarchy-dynamic-theme.timer" ~/.config/systemd/user/
            
            # Reload systemd
            systemctl --user daemon-reload
            
            echo "Dynamic theme switcher installed."
            read -p "Do you want to enable the dynamic theme switcher (auto switch Day/Night)? (y/N) " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                systemctl --user enable --now omarchy-dynamic-theme.timer
                echo "Dynamic theme switcher enabled! Running initial check..."
                "$dest_dir/scripts/dynamic-theme.sh"
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
