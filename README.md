# Ravenwood Themes for Omarchy

A custom theme collection with emerald green accents for Omarchy, available in both Dark and Light variants.

## Themes Included

*   **Ravenwood (Dark):** Deep forest green and dark grey (`#1a1f1c`) with emerald accents (`#4ade80`).
*   **Ravenwood Light:** A lighter, airy variant with the same emerald accents.

## Installation

### Manual Installation

1.  Clone this repository:
    ```bash
    git clone https://github.com/yourusername/omarchy-ravenwood-theme.git
    cd omarchy-ravenwood-theme
    ```
2.  Run the installation script:
    ```bash
    ./install.sh
    ```
    This will install both `ravenwood` and `ravenwood-light` to your `~/.config/omarchy/themes/` directory and ask which one you want to apply.

### Using `omarchy-theme-install`

Once this repository is hosted on GitHub/GitLab, you can install it using the Omarchy theme manager:

```bash
omarchy-theme-install https://github.com/yourusername/omarchy-ravenwood-theme.git
```

**Note:** The `omarchy-theme-install` tool might expect a single theme at the root. If it fails to detect both themes automatically, simply run `./install.sh` from inside the downloaded directory:

```bash
cd ~/.config/omarchy/themes/ravenwood-theme # (or wherever it cloned)
./install.sh
```

## Theme Details

### Ravenwood (Dark)
*   **Colors:** Dark background (`#1a1f1c`) with emerald green accents (`#4ade80`).
*   **Background:** `1-ravenwood-foggy-mountain.jpg` (Credit: Dharmx).

### Ravenwood Light
*   **Colors:** Light background with matching emerald accents.
*   **Background:** `1-ravenwood-light.jpg`.

## Credits

Based on the [Omarchy](https://omarchy.org/) theme structure.
