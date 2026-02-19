#!/bin/bash
set -e

THEMES_DIR="$HOME/.config/omarchy/themes"

install_theme() {
    local theme_name="$1"
    local source_dir="$theme_name"
    local dest_dir="$THEMES_DIR/$theme_name"

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
    if [ "$theme_name" == "ravenwood" ]; then
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
        if [ -d "$dest_dir/scripts" ]; then
            echo "Setting up dynamic theme scheduling..."
            mkdir -p ~/.config/systemd/user
            
            # Link service files
            ln -sf "$dest_dir/scripts/omarchy-dynamic-theme.service" ~/.config/systemd/user/
            ln -sf "$dest_dir/scripts/omarchy-dynamic-theme.timer" ~/.config/systemd/user/
            
            # Reload systemd
            systemctl --user daemon-reload
            
            # Enable and start timer if requested
            read -p "Do you want to enable the dynamic theme switcher (auto switch Day/Night)? (y/N) " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                systemctl --user enable --now omarchy-dynamic-theme.timer
                echo "Dynamic theme switcher enabled!"
                # Run once immediately to set correct theme
                "$dest_dir/scripts/dynamic-theme.sh"
            else
                echo "Skipping dynamic theme setup."
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

# Offer to apply
if command -v omarchy-theme-set &> /dev/null; then
    echo
    echo "Which theme would you like to apply now?"
    echo "1) Ravenwood (Dark)"
    echo "2) Ravenwood Light"
    echo "3) None (skip)"
    echo
    read -p "Enter your choice (1/2/3): " choice
    
    case $choice in
        1)
            omarchy-theme-set "ravenwood"
            ;;
        2)
            omarchy-theme-set "ravenwood-light"
            ;;
        *)
            echo "Skipping theme application."
            ;;
    esac
else
    echo "omarchy-theme-set not found. You may need to apply the theme manually."
fi
