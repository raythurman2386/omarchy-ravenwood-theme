# Ravenwood Themes for Omarchy

A custom theme collection with emerald green accents for Omarchy, available in both Dark and Light variants. Also includes static themes for VS Code and Zed.

## Themes Included

*   **Ravenwood (Dark):** Deep forest green (`#222822`) with emerald accents (`#4ade80`).
*   **Ravenwood Light:** A lighter, airy variant with the same emerald accents.

## Editor Themes

This repo also ships static theme files for other editors:

| Editor | File | Variants |
|--------|------|----------|
| VS Code | `vscode/ravenwood-dark.json`, `vscode/ravenwood-light.json` | Ravenwood Dark, Ravenwood Light |
| Zed | `zed/ravenwood.json` | Ravenwood Dark, Ravenwood Light |

The installer auto-detects the VS Code extension (`raymondthurman.ravenwood`) — if installed, static VS Code themes are skipped. Zed themes are always installed to `~/.config/zed/themes/`.

## Installation

### Manual Installation

1.  Clone this repository:
    ```bash
    git clone https://github.com/raythurman2386/omarchy-ravenwood-theme.git
    cd omarchy-ravenwood-theme
    ```
2.  Run the installation script:
    ```bash
    ./install.sh
    ```
    This installs:
    - `ravenwood` and `ravenwood-light` to `~/.config/omarchy/themes/`
    - VS Code static themes to `~/.config/omarchy/themes/vscode/` (if extension not detected)
    - Zed theme to `~/.config/zed/themes/ravenwood.json` (if Zed is installed)

### Using `omarchy-theme-install`

You can use the standard theme installer to download the repository, but you **must** run the included install script afterward to set up the dual themes correctly.

1.  Download the theme repository:
    ```bash
    omarchy-theme-install https://github.com/raythurman2386/omarchy-ravenwood-theme.git
    ```
    *(Note: The initial automatic theme application might fail or look incorrect because this repo contains two themes. This is normal.)*

2.  Run the setup script to install both Dark and Light variants:
    ```bash
    cd ~/.config/omarchy/themes/ravenwood
    ./install.sh
    ```

## Applying Themes

- **Omarchy:** `omarchy-theme-set ravenwood` / `omarchy-theme-set ravenwood-light`
- **VS Code:** Command Palette → Preferences: Color Theme → Ravenwood Dark / Light
- **Zed:** `ctrl-k ctrl-t` → Ravenwood Dark / Ravenwood Light

## Theme Details

### Ravenwood (Dark)
*   **Colors:** Dark background (`#222822`) with emerald green accents (`#4ade80`).
*   **Background:** `1-ravenwood-foggy-mountain.jpg` (Credit: Dharmx).

### Ravenwood Light
*   **Colors:** Light background (`#f5f4ed`) with deep emerald accents (`#064e3b`).
*   **Background:** `1-ravenwood-light.jpg`.

## Credits

Based on the [Omarchy](https://omarchy.org/) theme structure.
