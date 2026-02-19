#!/bin/bash
set -e

THEME_NAME="ravenwood"
DEST_DIR="$HOME/.config/omarchy/themes/$THEME_NAME"

echo "Installing $THEME_NAME theme to $DEST_DIR..."

# Ensure the destination directory exists
mkdir -p "$DEST_DIR"

# Copy files. Exclude .git and this script.
# Using cp with a glob pattern can be messy if hidden files exist.
# A simpler approach is to copy everything and remove what we don't want,
# or list files to copy explicitly.
# Let's list files to copy:
FILES_TO_COPY=(
    "backgrounds"
    "btop.theme"
    "colors.toml"
    "icons.theme"
    "neovim.lua"
    "preview.png"
    "vscode.json"
)

for item in "${FILES_TO_COPY[@]}"; do
    if [ -e "$item" ]; then
        cp -r "$item" "$DEST_DIR/"
    else
        echo "Warning: $item not found in source directory."
    fi
done

echo "Theme installed successfully!"

# Check if omarchy-theme-set is available before offering to apply
if command -v omarchy-theme-set &> /dev/null; then
    read -p "Do you want to apply the theme now? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        omarchy-theme-set "$THEME_NAME"
    fi
else
    echo "omarchy-theme-set not found. You may need to apply the theme manually."
fi
