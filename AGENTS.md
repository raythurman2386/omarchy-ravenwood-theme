# AGENTS.md - Instructions for AI Coding Agents

This file provides machine-readable context and instructions for AI agents (like OpenCode) interacting with the `omarchy-ravenwood-theme` repository.

## Project Overview
- **Purpose:** A dual-variant (Dark/Light) theme collection for the Omarchy environment.
- **Main Components:**
  - `ravenwood/`: Dark theme assets and configuration.
  - `ravenwood-light/`: Light theme assets and configuration.
  - `install.sh`: Central installation and configuration script.
  - `ravenwood/scripts/dynamic-theme.sh`: Logic for automatic theme switching based on time.

## Critical Paths & Files
- **Root:** `.`
- **Themes Source:** `./ravenwood`, `./ravenwood-light`
- **Installation Target:** `~/.config/omarchy/themes/`
- **Color Definitions:** `**/colors.toml` (TOML format)
- **App Configs:** `**/neovim.lua`, `**/vscode.json`, `**/btop.theme`
- **Systemd Units:** `ravenwood/scripts/omarchy-dynamic-theme.{service,timer}`

## Environment Setup & Commands

### Installation
Run the following to install both themes and optionally set up dynamic switching:
```bash
./install.sh
```

### Theme Application
Themes are applied via the `omarchy` CLI:
- Apply Dark: `omarchy-theme-set ravenwood`
- Apply Light: `omarchy-theme-set ravenwood-light`
- Check Current: `omarchy-theme-current`

## Development Guidelines

### Shell Scripting
- Use `#!/bin/bash`.
- Use `set -e` for error handling.
- Use `local` variables within functions.
- Prefer `omarchy` CLI commands for theme management.

### Configuration
- `colors.toml` is the source of truth for color palettes.
- Ensure hex codes are consistent across application-specific config files (`vscode.json`, etc.).

### Dynamic Theme Logic
- The `dynamic-theme.sh` script maps time ranges to `ravenwood` and `ravenwood-light`.
- It identifies if the user is currently using a "managed" theme (one of the Ravenwood variants) before attempting to switch, ensuring it doesn't disrupt users on other themes.

## Testing & Validation
- **Manual Verification:** After installation, verify symlinks or files exist in `~/.config/omarchy/themes/`.
- **Script Validation:** Run `bash -n install.sh` and `bash -n ravenwood/scripts/dynamic-theme.sh` to check for syntax errors.
