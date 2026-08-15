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
*   **Plymouth:** Ships `unlock.png` + `preview-unlock.png` for the boot/login screen.

### Ravenwood Light
*   **Colors:** Light background (`#f5f4ed`) with deep emerald accents (`#064e3b`).
*   **Background:** `1-ravenwood-light.jpg`.
*   **Plymouth:** Ships `unlock.png` + `preview-unlock.png` for the boot/login screen.

## Omarchy Quattro (v4.0.0) Compatibility

Both `colors.toml` files use the **semantic palette schema** introduced in Omarchy Quattro:

- `mode` (`dark` / `light`), `accent`, `selection`, `muted`
- `background` / `dark_background` / `darker_background` / `lighter_background`
- `foreground` / `dark_foreground` / `light_foreground` / `bright_foreground`
- Named accents: `red`, `yellow`, `orange`, `green`, `cyan`, `blue`, `magenta`, `brown` (+ `bright_*` variants)

The legacy `color0`–`color15` ANSI keys are kept for terminal consumers that reference them directly. The Quattro resolver maps semantic keys to the full (non-dim) accent colors, so the shell bar's active/error color and Hyprland borders use the correct full accents.

To apply the theme to the Plymouth boot screen:
```bash
omarchy plymouth set by theme ravenwood
omarchy plymouth set by theme ravenwood-light
```

### Hermes TUI skin sync

A theme-set hook (`ravenwood/scripts/omarchy-theme-set-hermes-skin.hook`, installed to `~/.config/omarchy/hooks/theme-set.d/`) flips the Hermes TUI skin so text stays legible on the light/dark terminal background. It runs on **every** `omarchy-theme-set` (manual, timer, or waybar widget), not just the timer.

The Hermes TUI can't reliably detect foot's background (no `TERM_PROGRAM`/`COLORFGBG`, and the OSC-11 probe is silent), so the hook pins the skin explicitly:

- **`ravenwood-light`** → `ravenwood-light` skin (a custom skin in `~/.hermes/skins/ravenwood-light.yaml` that authors a light `background`, forcing the TUI to render light)
- **`ravenwood`** → `default` (dark) skin

Edit the hook to change the mapping.

## Credits

Based on the [Omarchy](https://omarchy.org/) theme structure.
