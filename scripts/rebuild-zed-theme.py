#!/usr/bin/env python3
"""Rebuild the Zed Ravenwood theme to match VS Code extension output exactly."""
import json

# Load VS Code themes
with open('/home/ret/Work/ravenwood-vscode/themes/ravenwood-dark.json') as f:
    vsc_dark = json.load(f)
with open('/home/ret/Work/ravenwood-vscode/themes/ravenwood-light.json') as f:
    vsc_light = json.load(f)

vsc_dark_colors = vsc_dark['colors']
vsc_light_colors = vsc_light['colors']

# Helper: ensure 8-char hex with alpha
def hex8(c):
    """Convert VS Code 6-char hex or 8-char hex to 8-char with alpha."""
    if not isinstance(c, str) or not c.startswith('#'):
        return c
    c = c.strip()
    if len(c) == 7:  # #RRGGBB
        return c + 'ff'
    elif len(c) == 9:  # #RRGGBBAA
        return c
    return c

# Helper: get a color from VS Code, with fallback
def vsc_get(colors, key, fallback='#00000000'):
    v = colors.get(key, fallback)
    return hex8(v)

# Build the Zed theme style from VS Code colors
def build_style(vsc_c, vsc_tokens, appearance):
    is_dark = appearance == 'dark'
    
    # Core editor
    editor_bg = vsc_get(vsc_c, 'editor.background', '#222822' if is_dark else '#f5f4ed')
    editor_fg = vsc_get(vsc_c, 'editor.foreground', '#e8d5b7' if is_dark else '#3f4a45')
    
    # UI surface colors
    sidebar_bg = vsc_get(vsc_c, 'sideBar.background', editor_bg)
    activity_bg = vsc_get(vsc_c, 'activityBar.background', '#1f241f' if is_dark else '#dcdbd6')
    title_bg = vsc_get(vsc_c, 'titleBar.activeBackground', '#1f241f' if is_dark else '#dcdbd6')
    title_inactive_bg = vsc_get(vsc_c, 'titleBar.inactiveBackground', '#1f241f' if is_dark else '#dcdbd6')
    status_bg = vsc_get(vsc_c, 'statusBar.background', '#1f241f' if is_dark else '#dcdbd6')
    tab_active_bg = vsc_get(vsc_c, 'tab.activeBackground', editor_bg)
    tab_inactive_bg = vsc_get(vsc_c, 'tab.inactiveBackground', editor_bg)
    panel_bg = vsc_get(vsc_c, 'panel.background', sidebar_bg)
    toolbar_bg = vsc_get(vsc_c, 'toolbar.background', editor_bg)
    tab_bar_bg = vsc_get(vsc_c, 'tab_bar.background', sidebar_bg)
    
    # Text colors
    text_fg = vsc_get(vsc_c, 'editor.foreground', editor_fg)
    text_muted = vsc_get(vsc_c, 'sideBarSectionHeader.foreground', '#9aa79d' if is_dark else '#7a8478')
    text_placeholder = vsc_get(vsc_c, 'input.placeholderForeground', '#7f897d' if is_dark else '#a0a89e')
    text_disabled = vsc_get(vsc_c, 'disabledForeground', '#7f897d' if is_dark else '#a0a89e')
    text_accent = vsc_get(vsc_c, 'activityBarBadge.background', '#4ade80' if is_dark else '#064e3b')
    
    # Icon colors
    icon_fg = vsc_get(vsc_c, 'activityBar.foreground', text_fg)
    icon_muted = text_muted
    icon_disabled = text_disabled
    icon_accent = text_accent
    
    # Border colors
    border = vsc_get(vsc_c, 'widget.border', '#5a6a5d' if is_dark else '#c8ccc6')
    border_variant = vsc_get(vsc_c, 'sideBar.border', border)
    border_focused = vsc_get(vsc_c, 'focusBorder', text_accent)
    border_selected = vsc_get(vsc_c, 'list.activeSelectionBackground', '#4a5a4d80' if is_dark else '#c8ccc6')
    border_disabled = vsc_get(vsc_c, 'editorWidget.border', border)
    
    # Element colors
    element_bg = vsc_get(vsc_c, 'input.background', '#22282200' if is_dark else '#f5f4ed00')
    element_hover = vsc_get(vsc_c, 'list.hoverBackground', '#22282200' if is_dark else '#e8e7e200')
    element_active = vsc_get(vsc_c, 'list.focusBackground', '#4a5a4d80' if is_dark else '#c8ccc6')
    element_selected = vsc_get(vsc_c, 'list.activeSelectionBackground', '#4a5a4d80' if is_dark else '#c8ccc6')
    element_disabled = element_bg
    
    # Surface
    surface_bg = vsc_get(vsc_c, 'sideBar.background', sidebar_bg)
    elevated_surface_bg = vsc_get(vsc_c, 'editorWidget.background', editor_bg)
    
    # Ghost element
    ghost_bg = '#00000000'
    ghost_hover = element_hover
    ghost_active = element_active
    ghost_selected = element_selected
    ghost_disabled = element_disabled
    
    # Drop target
    drop_target = vsc_get(vsc_c, 'editor.dropBackground', '#4ade8040' if is_dark else '#064e3b40')
    
    # Search
    search_match = vsc_get(vsc_c, 'editor.findMatchBackground', '#d77f4840' if is_dark else '#064e3b44')
    search_active_match = vsc_get(vsc_c, 'editor.findMatchHighlightBackground', '#5e8d5e40' if is_dark else '#92400e44')
    
    # Scrollbar
    scroll_thumb = vsc_get(vsc_c, 'scrollbarSlider.background', '#5a6a5d80' if is_dark else '#5c665880')
    scroll_thumb_hover = vsc_get(vsc_c, 'scrollbarSlider.hoverBackground', '#5a6a5d' if is_dark else '#5c6658')
    scroll_thumb_border = scroll_thumb_hover
    scroll_track_bg = '#00000000'
    scroll_track_border = vsc_get(vsc_c, 'editorGutter.background', editor_bg)
    
    # Editor specific
    editor_gutter_bg = vsc_get(vsc_c, 'editorGutter.background', '#22282200' if is_dark else '#f5f4ed00')
    editor_subheader_bg = vsc_get(vsc_c, 'editorGroupHeader.tabsBackground', sidebar_bg)
    editor_active_line = vsc_get(vsc_c, 'editor.lineHighlightBackground', '#4a5a4d40' if is_dark else '#e8e7e2bf')
    editor_highlighted_line = vsc_get(vsc_c, 'editor.lineHighlightBackground', '#4a5a4d40' if is_dark else '#e8e7e2bf')
    editor_line_number = vsc_get(vsc_c, 'editorLineNumber.foreground', '#7f897da0' if is_dark else '#a0a89e')
    editor_active_line_number = vsc_get(vsc_c, 'editorLineNumber.activeForeground', '#9aa79de0' if is_dark else '#3f4a45')
    editor_hover_line_number = vsc_get(vsc_c, 'editorLineNumber.dimmedForeground', '#7f897d60' if is_dark else '#7a8478')
    editor_invisible = vsc_get(vsc_c, 'editorWhitespace.foreground', '#5a6a5d' if is_dark else '#a0a89e')
    editor_wrap_guide = vsc_get(vsc_c, 'editorIndentGuide.background', '#5a6a5d40' if is_dark else '#5c665866')
    editor_active_wrap_guide = vsc_get(vsc_c, 'editorIndentGuide.activeBackground', '#5a6a5d80' if is_dark else '#5c6658aa')
    editor_doc_highlight_read = vsc_get(vsc_c, 'editor.wordHighlightBackground', '#4a5a4d58' if is_dark else '#064e3b25')
    editor_doc_highlight_write = vsc_get(vsc_c, 'editor.wordHighlightStrongBackground', '#4a5a4db0' if is_dark else '#5c665866')
    
    # Terminal
    term_bg = vsc_get(vsc_c, 'terminal.background', editor_bg)
    term_fg = vsc_get(vsc_c, 'terminal.foreground', editor_fg)
    term_bright_fg = vsc_get(vsc_c, 'terminal.ansiBrightWhite', editor_fg)
    term_dim_fg = vsc_get(vsc_c, 'terminal.ansiBrightBlack', '#859289' if is_dark else '#7a8478')
    
    # Terminal ANSI
    ansi_keys = ['Black', 'Red', 'Green', 'Yellow', 'Blue', 'Magenta', 'Cyan', 'White']
    ansi = {}
    for k in ansi_keys:
        ansi[k.lower()] = vsc_get(vsc_c, f'terminal.ansi{k}', '#000000')
        ansi[f'bright_{k.lower()}'] = vsc_get(vsc_c, f'terminal.ansiBright{k}', '#ffffff')
        ansi[f'dim_{k.lower()}'] = vsc_get(vsc_c, f'terminal.ansiDim{k}', '#000000')
    
    # Git / VCS
    vcs_added = vsc_get(vsc_c, 'gitDecoration.addedResourceForeground', text_accent)
    vcs_modified = vsc_get(vsc_c, 'gitDecoration.modifiedResourceForeground', '#fbbf24' if is_dark else '#92400e')
    vcs_deleted = vsc_get(vsc_c, 'gitDecoration.deletedResourceForeground', '#e67e80' if is_dark else '#9b1c1c')
    vcs_word_added = vsc_get(vsc_c, 'diffEditor.insertedTextBackground', '#4ade8059' if is_dark else '#064e3b59')
    vcs_word_deleted = vsc_get(vsc_c, 'diffEditor.removedTextBackground', '#e67e80cc' if is_dark else '#9b1c1ccc')
    
    # Status indicators
    error_c = vsc_get(vsc_c, 'errorForeground', '#e67e80' if is_dark else '#c92a2a')
    warning_c = vsc_get(vsc_c, 'warningForeground', '#fbbf24' if is_dark else '#92400e')
    info_c = vsc_get(vsc_c, 'infoForeground', '#22d3ee' if is_dark else '#2563eb')
    success_c = vsc_get(vsc_c, 'gitDecoration.addedResourceForeground', text_accent)
    hidden_c = vsc_get(vsc_c, 'gitDecoration.ignoredResourceForeground', '#7f897d' if is_dark else '#a0a89e')
    ignored_c = hidden_c
    hint_c = info_c
    predictive_c = vsc_get(vsc_c, 'editorGhostText.foreground', '#5a6a5d' if is_dark else '#7a8478')
    modified_c = vcs_modified
    created_c = vcs_added
    deleted_c = vcs_deleted
    renamed_c = info_c
    conflict_c = warning_c
    unreachable_c = text_muted
    
    # Build the style dict
    style = {
        'border': border,
        'border.variant': border_variant,
        'border.focused': border_focused,
        'border.selected': border_selected,
        'border.transparent': '#00000000',
        'border.disabled': border_disabled,
        'elevated_surface.background': elevated_surface_bg,
        'surface.background': surface_bg,
        'background': vsc_get(vsc_c, 'activityBar.background', activity_bg),
        'element.background': element_bg,
        'element.hover': element_hover,
        'element.active': element_active,
        'element.selected': element_selected,
        'element.disabled': element_disabled,
        'drop_target.background': drop_target,
        'ghost_element.background': ghost_bg,
        'ghost_element.hover': ghost_hover,
        'ghost_element.active': ghost_active,
        'ghost_element.selected': ghost_selected,
        'ghost_element.disabled': ghost_disabled,
        'text': text_fg,
        'text.muted': text_muted,
        'text.placeholder': text_placeholder,
        'text.disabled': text_disabled,
        'text.accent': text_accent,
        'icon': icon_fg,
        'icon.muted': icon_muted,
        'icon.disabled': icon_disabled,
        'icon.placeholder': icon_muted,
        'icon.accent': icon_accent,
        'status_bar.background': status_bg,
        'title_bar.background': title_bg,
        'title_bar.inactive_background': title_inactive_bg,
        'toolbar.background': toolbar_bg,
        'tab_bar.background': tab_bar_bg,
        'tab.inactive_background': tab_inactive_bg,
        'tab.active_background': tab_active_bg,
        'search.match_background': search_match,
        'search.active_match_background': search_active_match,
        'panel.background': panel_bg,
        'panel.focused_border': None,
        'pane.focused_border': None,
        'scrollbar.thumb.background': scroll_thumb,
        'scrollbar.thumb.hover_background': scroll_thumb_hover,
        'scrollbar.thumb.border': scroll_thumb_border,
        'scrollbar.track.background': scroll_track_bg,
        'scrollbar.track.border': scroll_track_border,
        'editor.foreground': editor_fg,
        'editor.background': editor_bg,
        'editor.gutter.background': editor_gutter_bg,
        'editor.subheader.background': editor_subheader_bg,
        'editor.active_line.background': editor_active_line,
        'editor.highlighted_line.background': editor_highlighted_line,
        'editor.line_number': editor_line_number,
        'editor.active_line_number': editor_active_line_number,
        'editor.hover_line_number': editor_hover_line_number,
        'editor.invisible': editor_invisible,
        'editor.wrap_guide': editor_wrap_guide,
        'editor.active_wrap_guide': editor_active_wrap_guide,
        'editor.document_highlight.read_background': editor_doc_highlight_read,
        'editor.document_highlight.write_background': editor_doc_highlight_write,
        'terminal.background': term_bg,
        'terminal.foreground': term_fg,
        'terminal.bright_foreground': term_bright_fg,
        'terminal.dim_foreground': term_dim_fg,
        'terminal.ansi.black': ansi['black'],
        'terminal.ansi.bright_black': ansi['bright_black'],
        'terminal.ansi.dim_black': ansi['dim_black'],
        'terminal.ansi.red': ansi['red'],
        'terminal.ansi.bright_red': ansi['bright_red'],
        'terminal.ansi.dim_red': ansi['dim_red'],
        'terminal.ansi.green': ansi['green'],
        'terminal.ansi.bright_green': ansi['bright_green'],
        'terminal.ansi.dim_green': ansi['dim_green'],
        'terminal.ansi.yellow': ansi['yellow'],
        'terminal.ansi.bright_yellow': ansi['bright_yellow'],
        'terminal.ansi.dim_yellow': ansi['dim_yellow'],
        'terminal.ansi.blue': ansi['blue'],
        'terminal.ansi.bright_blue': ansi['bright_blue'],
        'terminal.ansi.dim_blue': ansi['dim_blue'],
        'terminal.ansi.magenta': ansi['magenta'],
        'terminal.ansi.bright_magenta': ansi['bright_magenta'],
        'terminal.ansi.dim_magenta': ansi['dim_magenta'],
        'terminal.ansi.cyan': ansi['cyan'],
        'terminal.ansi.bright_cyan': ansi['bright_cyan'],
        'terminal.ansi.dim_cyan': ansi['dim_cyan'],
        'terminal.ansi.white': ansi['white'],
        'terminal.ansi.bright_white': ansi['bright_white'],
        'terminal.ansi.dim_white': ansi['dim_white'],
        'link_text.hover': text_accent,
        'version_control.added': vcs_added,
        'version_control.modified': vcs_modified,
        'version_control.word_added': vcs_word_added,
        'version_control.word_deleted': vcs_word_deleted,
        'version_control.deleted': vcs_deleted,
        'version_control.conflict_marker.ours': '#4ade801a' if is_dark else '#064e3b1a',
        'version_control.conflict_marker.theirs': '#22d3ee1a' if is_dark else '#2563eb1a',
        'conflict': conflict_c,
        'conflict.background': f'{conflict_c[:7]}1a',
        'conflict.border': f'{conflict_c[:7]}80',
        'created': created_c,
        'created.background': f'{created_c[:7]}1a',
        'created.border': f'{created_c[:7]}80',
        'deleted': deleted_c,
        'deleted.background': f'{deleted_c[:7]}1a',
        'deleted.border': f'{deleted_c[:7]}80',
        'error': error_c,
        'error.background': f'{error_c[:7]}1a',
        'error.border': f'{error_c[:7]}80',
        'hidden': hidden_c,
        'hidden.background': f'{hidden_c[:7]}1a',
        'hidden.border': f'{hidden_c[:7]}80',
        'hint': hint_c,
        'hint.background': f'{hint_c[:7]}1a',
        'hint.border': f'{hint_c[:7]}80',
        'ignored': ignored_c,
        'ignored.background': f'{ignored_c[:7]}1a',
        'ignored.border': f'{ignored_c[:7]}80',
        'info': info_c,
        'info.background': f'{info_c[:7]}1a',
        'info.border': f'{info_c[:7]}80',
        'modified': modified_c,
        'modified.background': f'{modified_c[:7]}1a',
        'modified.border': f'{modified_c[:7]}80',
        'predictive': predictive_c,
        'predictive.background': f'{predictive_c[:7]}1a',
        'predictive.border': f'{predictive_c[:7]}80',
        'renamed': renamed_c,
        'renamed.background': f'{renamed_c[:7]}1a',
        'renamed.border': f'{renamed_c[:7]}80',
        'success': success_c,
        'success.background': f'{success_c[:7]}1a',
        'success.border': f'{success_c[:7]}80',
        'unreachable': unreachable_c,
        'unreachable.background': f'{unreachable_c[:7]}1a',
        'unreachable.border': f'{unreachable_c[:7]}80',
        'warning': warning_c,
        'warning.background': f'{warning_c[:7]}1a',
        'warning.border': f'{warning_c[:7]}80',
        'players': [
            {'cursor': vsc_get(vsc_c, 'editorCursor.foreground', editor_fg), 'background': vsc_get(vsc_c, 'editorCursor.foreground', editor_fg), 'selection': '#4ade803d' if is_dark else '#064e3b3d'},
            {'cursor': '#e67e80ff' if is_dark else '#c92a2aff', 'background': '#e67e80ff' if is_dark else '#c92a2aff', 'selection': '#e67e803d' if is_dark else '#c92a2a3d'},
            {'cursor': '#fbbf24ff' if is_dark else '#92400eff', 'background': '#fbbf24ff' if is_dark else '#92400eff', 'selection': '#fbbf243d' if is_dark else '#92400e3d'},
            {'cursor': '#f472b6ff' if is_dark else '#c026a3ff', 'background': '#f472b6ff' if is_dark else '#c026a3ff', 'selection': '#f472b63d' if is_dark else '#c026a33d'},
            {'cursor': '#22d3eeff' if is_dark else '#2563ebff', 'background': '#22d3eeff' if is_dark else '#2563ebff', 'selection': '#22d3ee3d' if is_dark else '#2563eb3d'},
            {'cursor': '#e67e80ff' if is_dark else '#c92a2aff', 'background': '#e67e80ff' if is_dark else '#c92a2aff', 'selection': '#e67e803d' if is_dark else '#c92a2a3d'},
            {'cursor': '#fbbf24ff' if is_dark else '#92400eff', 'background': '#fbbf24ff' if is_dark else '#92400eff', 'selection': '#fbbf243d' if is_dark else '#92400e3d'},
            {'cursor': text_accent, 'background': text_accent, 'selection': '#4ade803d' if is_dark else '#064e3b3d'},
        ],
    }
    
    # Build syntax from VS Code tokenColors
    def syn(name, default_color):
        t = vsc_tokens.get(name, {})
        fg = t.get('settings', {}).get('foreground', default_color)
        font_style = t.get('settings', {}).get('fontStyle', None)
        font_weight = t.get('settings', {}).get('fontWeight', None)
        # Map fontStyle to Zed format
        if font_style == 'italic':
            zed_fs = 'italic'
        elif font_style == 'bold':
            zed_fs = None
            font_weight = 700
        elif font_style == 'italic bold':
            zed_fs = 'italic'
            font_weight = 700
        else:
            zed_fs = None
        return {
            'color': hex8(fg),
            'font_style': zed_fs,
            'font_weight': font_weight,
        }
    
    style['syntax'] = {
        'attribute': syn('Decorator', text_accent),
        'boolean': syn('Boolean', '#f472b6' if is_dark else '#c026a3'),
        'comment': syn('Comment', '#859289' if is_dark else '#7a8478'),
        'comment.doc': syn('Documentation', '#5e8d5e' if is_dark else '#5c6658'),
        'constant': syn('Constant', '#f472b6' if is_dark else '#c026a3'),
        'constructor': syn('Constructor', '#22d3ee' if is_dark else '#2563eb'),
        'embedded': syn('Embedded', editor_fg),
        'emphasis': {'color': editor_fg, 'font_style': 'italic', 'font_weight': None},
        'emphasis.strong': {'color': editor_fg, 'font_style': None, 'font_weight': 700},
        'enum': syn('Enum', '#22d3ee' if is_dark else '#0f766e'),
        'function': syn('Function', '#4ade80' if is_dark else '#064e3b'),
        'hint': syn('Hint', '#22d3ee' if is_dark else '#2563eb'),
        'keyword': syn('Keyword', '#e67e80' if is_dark else '#86198f'),
        'label': syn('Label', text_accent),
        'link_text': {'color': '#4ade80' if is_dark else '#064e3b', 'font_style': 'italic', 'font_weight': None},
        'link_uri': {'color': '#22d3ee' if is_dark else '#2563eb', 'font_style': None, 'font_weight': None},
        'namespace': syn('Namespace', '#f472b6' if is_dark else '#c026a3'),
        'number': syn('Number', '#f472b6' if is_dark else '#c026a3'),
        'operator': syn('Operator', '#e69875' if is_dark else '#c2410c'),
        'predictive': {'color': predictive_c, 'font_style': 'italic', 'font_weight': None},
        'preproc': syn('Preprocessor', '#e67e80' if is_dark else '#86198f'),
        'primary': {'color': editor_fg, 'font_style': None, 'font_weight': None},
        'property': syn('Property', '#e8d5b7' if is_dark else '#3f4a45'),
        'punctuation': {'color': editor_fg, 'font_style': None, 'font_weight': None},
        'punctuation.bracket': {'color': text_muted, 'font_style': None, 'font_weight': None},
        'punctuation.delimiter': {'color': text_muted, 'font_style': None, 'font_weight': None},
        'punctuation.list_marker': syn('Keyword', '#e67e80' if is_dark else '#86198f'),
        'punctuation.markup': syn('Keyword', '#e67e80' if is_dark else '#86198f'),
        'punctuation.special': syn('Keyword', '#e67e80' if is_dark else '#86198f'),
        'selector': syn('Tag', '#22d3ee' if is_dark else '#2563eb'),
        'selector.pseudo': syn('Attribute', text_accent),
        'string': syn('String', '#fbbf24' if is_dark else '#92400e'),
        'string.escape': syn('Escape', '#fbbf24' if is_dark else '#92400e'),
        'string.regex': syn('Regexp', '#fbbf24' if is_dark else '#92400e'),
        'string.special': syn('String', '#fbbf24' if is_dark else '#92400e'),
        'string.special.symbol': syn('String', '#fbbf24' if is_dark else '#92400e'),
        'tag': syn('Tag', '#22d3ee' if is_dark else '#2563eb'),
        'text.literal': syn('String', '#fbbf24' if is_dark else '#92400e'),
        'title': syn('Function', '#4ade80' if is_dark else '#064e3b'),
        'type': syn('Type', '#22d3ee' if is_dark else '#0f766e'),
        'variable': syn('Variable', editor_fg),
        'variable.parameter': syn('Parameter', '#22d3ee' if is_dark else '#2563eb'),
        'variable.special': syn('Variable', editor_fg),
        'variant': syn('Type', '#22d3ee' if is_dark else '#0f766e'),
        'diff.plus': syn('DiffInsert', text_accent),
        'diff.minus': syn('DiffDelete', '#e67e80' if is_dark else '#c92a2a'),
    }
    
    return style

# Build both themes
vsc_dark_tokens = {t.get('name', ''): t for t in vsc_dark.get('tokenColors', [])}
vsc_light_tokens = {t.get('name', ''): t for t in vsc_light.get('tokenColors', [])}
dark_style = build_style(vsc_dark_colors, vsc_dark_tokens, 'dark')
light_style = build_style(vsc_light_colors, vsc_light_tokens, 'light')

# Assemble the full theme file
theme = {
    '$schema': 'https://zed.dev/schema/themes/v0.2.0.json',
    'name': 'Ravenwood',
    'author': 'Raymond Thurman',
    'themes': [
        {
            'name': 'Ravenwood Dark',
            'appearance': 'dark',
            'style': dark_style,
        },
        {
            'name': 'Ravenwood Light',
            'appearance': 'light',
            'style': light_style,
        },
    ],
}

with open('/home/ret/Work/omarchy-ravenwood-theme/zed/ravenwood.json', 'w') as f:
    json.dump(theme, f, indent=2)

print("Zed theme regenerated from VS Code colors.")
print(f"Dark style keys: {len(dark_style)}")
print(f"Light style keys: {len(light_style)}")
print(f"Dark syntax keys: {len(dark_style.get('syntax', {}))}")
print(f"Light syntax keys: {len(light_style.get('syntax', {}))}")
