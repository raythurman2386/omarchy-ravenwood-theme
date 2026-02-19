# Ravenwood Themes for Omarchy

A custom theme collection with emerald green accents for Omarchy, available in both Dark and Light variants.

## Themes Included

*   **Ravenwood (Dark):** Deep forest green and dark grey (`#1a1f1c`) with emerald accents (`#4ade80`).
*   **Ravenwood Light:** A lighter, airy variant with the same emerald accents.

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
    This will install both `ravenwood` and `ravenwood-light` to your `~/.config/omarchy/themes/` directory and ask which one you want to apply.

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

## Theme Details

### Ravenwood (Dark)
*   **Colors:** Dark background (`#1a1f1c`) with emerald green accents (`#4ade80`).
*   **Background:** `1-ravenwood-foggy-mountain.jpg` (Credit: Dharmx).

### Ravenwood Light
*   **Colors:** Light background with matching emerald accents.
*   **Background:** `1-ravenwood-light.jpg`.

## Credits

Based on the [Omarchy](https://omarchy.org/) theme structure.
