#!/usr/bin/env python3
"""Compare VS Code Ravenwood Dark colors to Zed Ravenwood Dark and report real mismatches."""
import json

with open('/home/ret/Work/ravenwood-vscode/themes/ravenwood-dark.json') as f:
    vsc = json.load(f)

with open('/home/ret/Work/omarchy-ravenwood-theme/zed/ravenwood.json') as f:
    zed = json.load(f)

vsc_colors = vsc['colors']
zed_style = zed['themes'][0]['style']

def strip_alpha(c):
    """Normalize: strip alpha, lowercase."""
    if not isinstance(c, str) or not c.startswith('#'):
        return str(c).lower()
    c = c.lower()
    if len(c) == 9:  # #RRGGBBAA
        return c[:7]
    return c

# Map VS Code color keys to Zed style keys
mapping = {
    # Editor
    'editor.background': 'editor.background',
    'editor.foreground': 'editor.foreground',
    'editorLineNumber.foreground': 'editor.line_number',
    'editorLineNumber.activeForeground': 'editor.active_line_number',
    'editorLineNumber.dimmedForeground': 'editor.hover_line_number',
    'editorCursor.foreground': 'players[0].cursor',
    'editorGutter.background': 'editor.gutter.background',
    'editorWidget.background': 'elevated_surface.background',
    'editorHoverWidget.background': 'elevated_surface.background',
    'editorSuggestWidget.background': 'elevated_surface.background',
    # Sidebar
    'sideBar.background': 'panel.background',
    'sideBarSectionHeader.foreground': 'text.muted',
    # Activity bar
    'activityBar.background': 'status_bar.background',
    'activityBar.foreground': 'icon',
    'activityBarBadge.background': 'text.accent',
    # Status bar
    'statusBar.background': 'status_bar.background',
    'statusBar.noFolderBackground': 'status_bar.background',
    # Title bar
    'titleBar.activeBackground': 'title_bar.background',
    'titleBar.inactiveBackground': 'title_bar.inactive_background',
    # Tabs
    'tab.activeBackground': 'tab.active_background',
    'tab.inactiveBackground': 'tab.inactive_background',
    'tab.border': 'border',
    # Panel
    'panel.background': 'panel.background',
    # Input / Dropdown / Button
    'input.background': 'element.background',
    'input.border': 'border',
    'dropdown.background': 'element.background',
    'dropdown.border': 'border',
    'button.background': 'text.accent',
    'button.hoverBackground': 'text.accent',
    # Lists
    'list.activeSelectionBackground': 'element.selected',
    'list.hoverBackground': 'element.hover',
    'list.focusBackground': 'element.active',
    'list.inactiveSelectionBackground': 'element.selected',
    # Scrollbar
    'scrollbarSlider.background': 'scrollbar.thumb.background',
    'scrollbarSlider.hoverBackground': 'scrollbar.thumb.hover_background',
    'scrollbarSlider.activeBackground': 'scrollbar.thumb.hover_background',
    # Badge / Progress
    'badge.background': 'text.accent',
    'progressBar.background': 'text.accent',
    'focusBorder': 'border.focused',
    # Terminal
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

print("=== REAL mismatches (alpha-normalized) ===")
print(f"{'VS Code Key':<45} {'VS Code':<18} {'Zed Key':<40} {'Zed':<18}")
print("="*120)

real_mismatches = 0
for vsc_key, vsc_val in sorted(vsc_colors.items()):
    zed_key = mapping.get(vsc_key)
    if zed_key is None:
        continue
    zed_val = get_zed_val(zed_key)
    if strip_alpha(vsc_val) != strip_alpha(zed_val):
        real_mismatches += 1
        print(f"{vsc_key:<45} {str(vsc_val):<18} {zed_key:<40} {str(zed_val):<18}")

print(f"\nReal mismatches: {real_mismatches}")
print()

# Syntax tokens
print("=== Syntax token color comparison ===")
vsc_tokens = {t.get('name',''): t for t in vsc['tokenColors']}
zed_syntax = zed_style['syntax']

token_map = {
    'Comment': 'comment',
    'String': 'string',
    'Keyword': 'keyword',
    'Number': 'number',
    'Type': 'type',
    'Function': 'function',
    'Variable': 'variable',
    'Constant': 'constant',
    'Operator': 'operator',
    'Tag': 'tag',
    'Boolean': 'boolean',
    'Property': 'property',
    'Namespace': 'namespace',
    'Class': 'type',
    'Enum': 'enum',
    'Parameter': 'variable.parameter',
    'Decorator': 'attribute',
    'Preprocessor': 'preproc',
    'Storage': 'keyword',
}

syn_mismatches = 0
for vsc_name, zed_key in token_map.items():
    t = vsc_tokens.get(vsc_name, {})
    vsc_fg = t.get('settings', {}).get('foreground', '—')
    zs = zed_syntax.get(zed_key, {})
    zed_fg = zs.get('color', '—')
    if strip_alpha(vsc_fg) != strip_alpha(zed_fg):
        syn_mismatches += 1
        print(f"{vsc_name:<20} VS Code: {str(vsc_fg):<20} Zed({zed_key}): {str(zed_fg):<20}")

print(f"\nSyntax mismatches: {syn_mismatches}")
