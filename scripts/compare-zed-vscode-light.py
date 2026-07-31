#!/usr/bin/env python3
"""Compare VS Code Ravenwood Light colors to Zed Ravenwood Light."""
import json

with open('/home/ret/Work/ravenwood-vscode/themes/ravenwood-light.json') as f:
    vsc = json.load(f)

with open('/home/ret/Work/omarchy-ravenwood-theme/zed/ravenwood.json') as f:
    zed = json.load(f)

vsc_colors = vsc['colors']
zed_style = zed['themes'][1]['style']  # Light

def strip_alpha(c):
    if not isinstance(c, str) or not c.startswith('#'):
        return str(c).lower()
    c = c.lower()
    return c[:7] if len(c) == 9 else c

mapping = {
    'editor.background': 'editor.background',
    'editor.foreground': 'editor.foreground',
    'editorLineNumber.foreground': 'editor.line_number',
    'editorLineNumber.activeForeground': 'editor.active_line_number',
    'editorCursor.foreground': 'players[0].cursor',
    'editorGutter.background': 'editor.gutter.background',
    'sideBar.background': 'panel.background',
    'sideBarSectionHeader.foreground': 'text.muted',
    'activityBar.background': 'status_bar.background',
    'activityBar.foreground': 'icon',
    'activityBarBadge.background': 'text.accent',
    'statusBar.background': 'status_bar.background',
    'titleBar.activeBackground': 'title_bar.background',
    'titleBar.inactiveBackground': 'title_bar.inactive_background',
    'tab.activeBackground': 'tab.active_background',
    'tab.inactiveBackground': 'tab.inactive_background',
    'panel.background': 'panel.background',
    'input.background': 'element.background',
    'input.border': 'border',
    'dropdown.background': 'element.background',
    'dropdown.border': 'border',
    'button.background': 'text.accent',
    'list.activeSelectionBackground': 'element.selected',
    'list.hoverBackground': 'element.hover',
    'list.focusBackground': 'element.active',
    'scrollbarSlider.background': 'scrollbar.thumb.background',
    'scrollbarSlider.hoverBackground': 'scrollbar.thumb.hover_background',
    'badge.background': 'text.accent',
    'progressBar.background': 'text.accent',
    'focusBorder': 'border.focused',
    'terminal.background': 'terminal.background',
    'terminal.foreground': 'terminal.foreground',
    'terminal.ansiBlack': 'terminal.ansi.black',
    'terminal.ansiRed': 'terminal.ansi.red',
    'terminal.ansiGreen': 'terminal.ansi.green',
    'terminal.ansiYellow': 'terminal.ansi.yellow',
    'terminal.ansiBlue': 'terminal.ansi.blue',
    'terminal.ansiMagenta': 'terminal.ansi.magenta',
    'terminal.ansiCyan': 'terminal.ansi.cyan',
    'terminal.ansiWhite': 'terminal.ansi.white',
    'terminal.ansiBrightBlack': 'terminal.ansi.bright_black',
    'terminal.ansiBrightRed': 'terminal.ansi.bright_red',
    'terminal.ansiBrightGreen': 'terminal.ansi.bright_green',
    'terminal.ansiBrightYellow': 'terminal.ansi.bright_yellow',
    'terminal.ansiBrightBlue': 'terminal.ansi.bright_blue',
    'terminal.ansiBrightMagenta': 'terminal.ansi.bright_magenta',
    'terminal.ansiBrightCyan': 'terminal.ansi.bright_cyan',
    'terminal.ansiBrightWhite': 'terminal.ansi.bright_white',
}

def get_zed_val(key):
    if key == 'players[0].cursor':
        return zed_style.get('players', [{}])[0].get('cursor', '—')
    return zed_style.get(key, '—')

mismatches = 0
for vsc_key, vsc_val in sorted(vsc_colors.items()):
    zed_key = mapping.get(vsc_key)
    if zed_key is None:
        continue
    zed_val = get_zed_val(zed_key)
    if strip_alpha(vsc_val) != strip_alpha(zed_val):
        mismatches += 1
        print(f"{vsc_key:<45} {str(vsc_val):<18} {zed_key:<40} {str(zed_val):<18}")

print(f"\nLight theme mismatches: {mismatches}")
