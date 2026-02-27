-- Ravenwood Light Theme for Neovim
-- A custom colorscheme matching the Omarchy Ravenwood Light theme
-- Palette: Warm cream background with steel blue accents

local M = {}

-- Color palette
local colors = {
	bg = "#fdf6e3",
	fg = "#3d4c53",
	accent = "#1a6d9e",
	cursor = "#3d4c53",
	selection_bg = "#3d4c53",
	selection_fg = "#fdf6e3",
	
	-- ANSI colors
	black = "#e0dcc7",
	red = "#c03c39",
	green = "#5c7a0c",
	yellow = "#b08500",
	blue = "#1a6d9e",
	magenta = "#b84d94",
	cyan = "#1e7d5a",
	white = "#3d4c53",
	
	-- Bright variants
	bright_black = "#d8d3ba",
	bright_red = "#c03c39",
	bright_green = "#5c7a0c",
	bright_yellow = "#b08500",
	bright_blue = "#1a6d9e",
	bright_magenta = "#b84d94",
	bright_cyan = "#1e7d5a",
	bright_white = "#3d4c53",
	
	-- UI colors
	dark_bg = "#f5eed5",
	light_bg = "#ebe4cc",
	comment = "#8a9a8f",
	dimmed = "#6a7a70",
	line_nr = "#c5bdb0",
	line_nr_cursor = "#1a6d9e",
}

-- Helper function to set highlights
local function set_hl(group, opts)
	vim.api.nvim_set_hl(0, group, opts)
end

-- Apply the colorscheme
function M.setup()
	-- Reset highlights
	vim.cmd("highlight clear")
	if vim.fn.exists("syntax_on") then
		vim.cmd("syntax reset")
	end
	
	vim.g.colors_name = "ravenwood-light"
	vim.o.background = "light"
	vim.o.termguicolors = true
	
	-- Editor highlights
	set_hl("Normal", { fg = colors.fg, bg = colors.bg })
	set_hl("NormalFloat", { fg = colors.fg, bg = colors.dark_bg })
	set_hl("FloatBorder", { fg = colors.dimmed, bg = colors.dark_bg })
	set_hl("ColorColumn", { bg = colors.light_bg })
	set_hl("Conceal", { fg = colors.dimmed })
	set_hl("Cursor", { fg = colors.bg, bg = colors.cursor })
	set_hl("CursorIM", { fg = colors.bg, bg = colors.cursor })
	set_hl("CursorColumn", { bg = colors.light_bg })
	set_hl("CursorLine", { bg = colors.light_bg })
	set_hl("Directory", { fg = colors.blue })
	set_hl("DiffAdd", { bg = "#e8f5e9" })
	set_hl("DiffChange", { bg = "#e3f2fd" })
	set_hl("DiffDelete", { bg = "#ffebee" })
	set_hl("DiffText", { bg = "#c8e6c9" })
	set_hl("EndOfBuffer", { fg = colors.line_nr })
	set_hl("ErrorMsg", { fg = colors.red, bold = true })
	set_hl("VertSplit", { fg = colors.line_nr })
	set_hl("WinSeparator", { fg = colors.line_nr })
	set_hl("Folded", { fg = colors.dimmed, bg = colors.light_bg })
	set_hl("FoldColumn", { fg = colors.dimmed })
	set_hl("SignColumn", { fg = colors.dimmed, bg = colors.bg })
	set_hl("IncSearch", { fg = colors.bg, bg = colors.yellow })
	set_hl("Substitute", { fg = colors.bg, bg = colors.red })
	set_hl("LineNr", { fg = colors.line_nr })
	set_hl("LineNrAbove", { fg = colors.line_nr })
	set_hl("LineNrBelow", { fg = colors.line_nr })
	set_hl("CursorLineNr", { fg = colors.line_nr_cursor, bold = true })
	set_hl("MatchParen", { fg = colors.accent, bg = colors.light_bg, bold = true })
	set_hl("ModeMsg", { fg = colors.fg })
	set_hl("MsgArea", { fg = colors.fg, bg = colors.bg })
	set_hl("MsgSeparator", { fg = colors.line_nr })
	set_hl("MoreMsg", { fg = colors.green })
	set_hl("NonText", { fg = colors.line_nr })
	set_hl("NormalNC", { fg = colors.fg, bg = colors.bg })
	set_hl("Pmenu", { fg = colors.fg, bg = colors.dark_bg })
	set_hl("PmenuSel", { fg = colors.bg, bg = colors.accent })
	set_hl("PmenuSbar", { bg = colors.light_bg })
	set_hl("PmenuThumb", { bg = colors.dimmed })
	set_hl("Question", { fg = colors.green })
	set_hl("QuickFixLine", { bg = colors.light_bg })
	set_hl("Search", { fg = colors.bg, bg = colors.yellow })
	set_hl("SpecialKey", { fg = colors.dimmed })
	set_hl("SpellBad", { sp = colors.red, undercurl = true })
	set_hl("SpellCap", { sp = colors.yellow, undercurl = true })
	set_hl("SpellLocal", { sp = colors.cyan, undercurl = true })
	set_hl("SpellRare", { sp = colors.magenta, undercurl = true })
	set_hl("StatusLine", { fg = colors.fg, bg = colors.dark_bg })
	set_hl("StatusLineNC", { fg = colors.dimmed, bg = colors.dark_bg })
	set_hl("TabLine", { fg = colors.dimmed, bg = colors.dark_bg })
	set_hl("TabLineFill", { bg = colors.dark_bg })
	set_hl("TabLineSel", { fg = colors.fg, bg = colors.light_bg })
	set_hl("Title", { fg = colors.accent, bold = true })
	set_hl("Visual", { bg = colors.selection_bg, fg = colors.selection_fg })
	set_hl("VisualNOS", { bg = colors.light_bg })
	set_hl("WarningMsg", { fg = colors.yellow, bold = true })
	set_hl("Whitespace", { fg = colors.line_nr })
	set_hl("WildMenu", { fg = colors.bg, bg = colors.accent })
	
	-- Syntax highlights
	set_hl("Comment", { fg = colors.comment, italic = true })
	set_hl("Constant", { fg = colors.cyan })
	set_hl("String", { fg = colors.green })
	set_hl("Character", { fg = colors.green })
	set_hl("Number", { fg = colors.magenta })
	set_hl("Boolean", { fg = colors.magenta })
	set_hl("Float", { fg = colors.magenta })
	set_hl("Identifier", { fg = colors.fg })
	set_hl("Function", { fg = colors.blue })
	set_hl("Statement", { fg = colors.red })
	set_hl("Conditional", { fg = colors.red })
	set_hl("Repeat", { fg = colors.red })
	set_hl("Label", { fg = colors.red })
	set_hl("Operator", { fg = colors.yellow })
	set_hl("Keyword", { fg = colors.red })
	set_hl("Exception", { fg = colors.red })
	set_hl("PreProc", { fg = colors.yellow })
	set_hl("Include", { fg = colors.red })
	set_hl("Define", { fg = colors.red })
	set_hl("Macro", { fg = colors.yellow })
	set_hl("PreCondit", { fg = colors.yellow })
	set_hl("Type", { fg = colors.cyan })
	set_hl("StorageClass", { fg = colors.yellow })
	set_hl("Structure", { fg = colors.cyan })
	set_hl("Typedef", { fg = colors.yellow })
	set_hl("Special", { fg = colors.yellow })
	set_hl("SpecialChar", { fg = colors.yellow })
	set_hl("Tag", { fg = colors.blue })
	set_hl("Delimiter", { fg = colors.dimmed })
	set_hl("SpecialComment", { fg = colors.comment, italic = true })
	set_hl("Debug", { fg = colors.red })
	set_hl("Underlined", { underline = true })
	set_hl("Ignore", { fg = colors.dimmed })
	set_hl("Error", { fg = colors.red, bold = true })
	set_hl("Todo", { fg = colors.yellow, bg = colors.light_bg, bold = true })
	
	-- LSP highlights
	set_hl("LspReferenceText", { bg = colors.light_bg })
	set_hl("LspReferenceRead", { bg = colors.light_bg })
	set_hl("LspReferenceWrite", { bg = colors.light_bg })
	set_hl("LspCodeLens", { fg = colors.dimmed })
	set_hl("LspCodeLensSeparator", { fg = colors.line_nr })
	set_hl("LspSignatureActiveParameter", { fg = colors.accent, bold = true })
	
	-- Diagnostic highlights
	set_hl("DiagnosticError", { fg = colors.red })
	set_hl("DiagnosticWarn", { fg = colors.yellow })
	set_hl("DiagnosticInfo", { fg = colors.blue })
	set_hl("DiagnosticHint", { fg = colors.cyan })
	set_hl("DiagnosticVirtualTextError", { fg = colors.red, bg = "#ffebee" })
	set_hl("DiagnosticVirtualTextWarn", { fg = colors.yellow, bg = "#fff8e1" })
	set_hl("DiagnosticVirtualTextInfo", { fg = colors.blue, bg = "#e3f2fd" })
	set_hl("DiagnosticVirtualTextHint", { fg = colors.cyan, bg = "#e0f2f1" })
	set_hl("DiagnosticUnderlineError", { sp = colors.red, undercurl = true })
	set_hl("DiagnosticUnderlineWarn", { sp = colors.yellow, undercurl = true })
	set_hl("DiagnosticUnderlineInfo", { sp = colors.blue, undercurl = true })
	set_hl("DiagnosticUnderlineHint", { sp = colors.cyan, undercurl = true })
	set_hl("DiagnosticFloatingError", { fg = colors.red })
	set_hl("DiagnosticFloatingWarn", { fg = colors.yellow })
	set_hl("DiagnosticFloatingInfo", { fg = colors.blue })
	set_hl("DiagnosticFloatingHint", { fg = colors.cyan })
	set_hl("DiagnosticSignError", { fg = colors.red })
	set_hl("DiagnosticSignWarn", { fg = colors.yellow })
	set_hl("DiagnosticSignInfo", { fg = colors.blue })
	set_hl("DiagnosticSignHint", { fg = colors.cyan })
	
	-- Git highlights
	set_hl("GitSignsAdd", { fg = colors.green })
	set_hl("GitSignsChange", { fg = colors.yellow })
	set_hl("GitSignsDelete", { fg = colors.red })
	set_hl("GitSignsAddNr", { fg = colors.green })
	set_hl("GitSignsChangeNr", { fg = colors.yellow })
	set_hl("GitSignsDeleteNr", { fg = colors.red })
	set_hl("GitSignsAddLn", { bg = "#e8f5e9" })
	set_hl("GitSignsChangeLn", { bg = "#e3f2fd" })
	set_hl("GitSignsDeleteLn", { bg = "#ffebee" })
	
	-- Treesitter highlights
	set_hl("@attribute", { fg = colors.yellow })
	set_hl("@boolean", { fg = colors.magenta })
	set_hl("@character", { fg = colors.green })
	set_hl("@character.special", { fg = colors.yellow })
	set_hl("@comment", { fg = colors.comment, italic = true })
	set_hl("@comment.documentation", { fg = colors.comment, italic = true })
	set_hl("@conditional", { fg = colors.red })
	set_hl("@constant", { fg = colors.magenta })
	set_hl("@constant.builtin", { fg = colors.magenta })
	set_hl("@constant.macro", { fg = colors.yellow })
	set_hl("@constructor", { fg = colors.cyan })
	set_hl("@debug", { fg = colors.red })
	set_hl("@define", { fg = colors.red })
	set_hl("@exception", { fg = colors.red })
	set_hl("@field", { fg = colors.fg })
	set_hl("@float", { fg = colors.magenta })
	set_hl("@function", { fg = colors.blue })
	set_hl("@function.builtin", { fg = colors.blue })
	set_hl("@function.call", { fg = colors.blue })
	set_hl("@function.macro", { fg = colors.yellow })
	set_hl("@include", { fg = colors.red })
	set_hl("@keyword", { fg = colors.red })
	set_hl("@keyword.function", { fg = colors.red })
	set_hl("@keyword.operator", { fg = colors.red })
	set_hl("@keyword.return", { fg = colors.red })
	set_hl("@label", { fg = colors.red })
	set_hl("@macro", { fg = colors.yellow })
	set_hl("@method", { fg = colors.blue })
	set_hl("@method.call", { fg = colors.blue })
	set_hl("@namespace", { fg = colors.cyan })
	set_hl("@none", {})
	set_hl("@number", { fg = colors.magenta })
	set_hl("@operator", { fg = colors.yellow })
	set_hl("@parameter", { fg = colors.fg })
	set_hl("@parameter.reference", { fg = colors.fg })
	set_hl("@preproc", { fg = colors.yellow })
	set_hl("@property", { fg = colors.fg })
	set_hl("@punctuation.bracket", { fg = colors.dimmed })
	set_hl("@punctuation.delimiter", { fg = colors.dimmed })
	set_hl("@punctuation.special", { fg = colors.dimmed })
	set_hl("@repeat", { fg = colors.red })
	set_hl("@storageclass", { fg = colors.yellow })
	set_hl("@string", { fg = colors.green })
	set_hl("@string.escape", { fg = colors.yellow })
	set_hl("@string.regex", { fg = colors.yellow })
	set_hl("@string.special", { fg = colors.yellow })
	set_hl("@symbol", { fg = colors.cyan })
	set_hl("@tag", { fg = colors.red })
	set_hl("@tag.attribute", { fg = colors.yellow })
	set_hl("@tag.delimiter", { fg = colors.dimmed })
	set_hl("@text", { fg = colors.fg })
	set_hl("@text.bold", { fg = colors.fg, bold = true })
	set_hl("@text.danger", { fg = colors.red })
	set_hl("@text.diff.add", { bg = "#e8f5e9" })
	set_hl("@text.diff.delete", { bg = "#ffebee" })
	set_hl("@text.emphasis", { italic = true })
	set_hl("@text.environment", { fg = colors.cyan })
	set_hl("@text.environment.name", { fg = colors.cyan })
	set_hl("@text.literal", { fg = colors.green })
	set_hl("@text.math", { fg = colors.blue })
	set_hl("@text.note", { fg = colors.blue })
	set_hl("@text.reference", { fg = colors.yellow })
	set_hl("@text.strike", { strikethrough = true })
	set_hl("@text.strong", { bold = true })
	set_hl("@text.title", { fg = colors.accent, bold = true })
	set_hl("@text.underline", { underline = true })
	set_hl("@text.uri", { fg = colors.blue, underline = true })
	set_hl("@text.warning", { fg = colors.yellow })
	set_hl("@type", { fg = colors.cyan })
	set_hl("@type.builtin", { fg = colors.cyan })
	set_hl("@type.definition", { fg = colors.cyan })
	set_hl("@type.qualifier", { fg = colors.red })
	set_hl("@variable", { fg = colors.fg })
	set_hl("@variable.builtin", { fg = colors.magenta })
	
	-- WhichKey highlights
	set_hl("WhichKey", { fg = colors.accent })
	set_hl("WhichKeyGroup", { fg = colors.blue })
	set_hl("WhichKeySeparator", { fg = colors.dimmed })
	set_hl("WhichKeyDesc", { fg = colors.fg })
	set_hl("WhichKeyFloat", { bg = colors.dark_bg })
	set_hl("WhichKeyValue", { fg = colors.dimmed })
	
	-- Telescope highlights
	set_hl("TelescopeNormal", { fg = colors.fg, bg = colors.dark_bg })
	set_hl("TelescopeBorder", { fg = colors.dimmed, bg = colors.dark_bg })
	set_hl("TelescopePromptNormal", { fg = colors.fg, bg = colors.light_bg })
	set_hl("TelescopePromptBorder", { fg = colors.dimmed, bg = colors.light_bg })
	set_hl("TelescopePromptTitle", { fg = colors.bg, bg = colors.accent })
	set_hl("TelescopePreviewTitle", { fg = colors.bg, bg = colors.blue })
	set_hl("TelescopeResultsTitle", { fg = colors.bg, bg = colors.magenta })
	set_hl("TelescopeSelection", { fg = colors.fg, bg = colors.light_bg })
	set_hl("TelescopeSelectionCaret", { fg = colors.accent })
	set_hl("TelescopeMatching", { fg = colors.accent, bold = true })
	
	-- Neo-tree highlights
	set_hl("NeoTreeNormal", { fg = colors.fg, bg = colors.dark_bg })
	set_hl("NeoTreeNormalNC", { fg = colors.fg, bg = colors.dark_bg })
	set_hl("NeoTreeRootName", { fg = colors.accent, bold = true })
	set_hl("NeoTreeFileName", { fg = colors.fg })
	set_hl("NeoTreeFileNameOpened", { fg = colors.accent, bold = true })
	set_hl("NeoTreeDirectoryName", { fg = colors.blue })
	set_hl("NeoTreeDirectoryIcon", { fg = colors.accent })
	set_hl("NeoTreeFileIcon", { fg = colors.cyan })
	set_hl("NeoTreeIndentMarker", { fg = colors.line_nr })
	set_hl("NeoTreeGitAdded", { fg = colors.green })
	set_hl("NeoTreeGitConflict", { fg = colors.red })
	set_hl("NeoTreeGitDeleted", { fg = colors.red })
	set_hl("NeoTreeGitIgnored", { fg = colors.dimmed })
	set_hl("NeoTreeGitModified", { fg = colors.yellow })
	set_hl("NeoTreeGitUnstaged", { fg = colors.red })
	set_hl("NeoTreeGitUntracked", { fg = colors.cyan })
	set_hl("NeoTreeGitStaged", { fg = colors.green })
	set_hl("NeoTreeFloatBorder", { fg = colors.dimmed, bg = colors.dark_bg })
	set_hl("NeoTreeFloatTitle", { fg = colors.bg, bg = colors.accent })
	
	-- Bufferline highlights (if used)
	set_hl("BufferLineFill", { bg = colors.dark_bg })
	set_hl("BufferLineBackground", { fg = colors.dimmed, bg = colors.dark_bg })
	set_hl("BufferLineBufferVisible", { fg = colors.dimmed, bg = colors.dark_bg })
	set_hl("BufferLineBufferSelected", { fg = colors.fg, bg = colors.light_bg, bold = true })
	set_hl("BufferLineTab", { fg = colors.dimmed, bg = colors.dark_bg })
	set_hl("BufferLineTabSelected", { fg = colors.bg, bg = colors.accent })
	set_hl("BufferLineTabClose", { fg = colors.red, bg = colors.dark_bg })
	set_hl("BufferLineIndicatorSelected", { fg = colors.accent, bg = colors.light_bg })
	set_hl("BufferLineSeparator", { fg = colors.dark_bg, bg = colors.dark_bg })
	set_hl("BufferLineSeparatorVisible", { fg = colors.dark_bg, bg = colors.dark_bg })
	set_hl("BufferLineSeparatorSelected", { fg = colors.dark_bg, bg = colors.light_bg })
	set_hl("BufferLineCloseButton", { fg = colors.dimmed, bg = colors.dark_bg })
	set_hl("BufferLineCloseButtonVisible", { fg = colors.dimmed, bg = colors.dark_bg })
	set_hl("BufferLineCloseButtonSelected", { fg = colors.red, bg = colors.light_bg })
	set_hl("BufferLineModified", { fg = colors.yellow, bg = colors.dark_bg })
	set_hl("BufferLineModifiedVisible", { fg = colors.yellow, bg = colors.dark_bg })
	set_hl("BufferLineModifiedSelected", { fg = colors.yellow, bg = colors.light_bg })
	
	-- Indent blankline highlights
	set_hl("IndentBlanklineChar", { fg = colors.line_nr })
	set_hl("IndentBlanklineSpaceChar", { fg = colors.line_nr })
	set_hl("IndentBlanklineContextChar", { fg = colors.accent })
	set_hl("IndentBlanklineContextStart", { sp = colors.accent, underline = true })
	
	-- Dashboard highlights (alpha.nvim)
	set_hl("AlphaHeader", { fg = colors.accent })
	set_hl("AlphaButtons", { fg = colors.blue })
	set_hl("AlphaShortcut", { fg = colors.yellow })
	set_hl("AlphaFooter", { fg = colors.dimmed })
	
	-- Notify highlights
	set_hl("NotifyERRORBorder", { fg = colors.red })
	set_hl("NotifyERRORIcon", { fg = colors.red })
	set_hl("NotifyERRORTitle", { fg = colors.red })
	set_hl("NotifyWARNBorder", { fg = colors.yellow })
	set_hl("NotifyWARNIcon", { fg = colors.yellow })
	set_hl("NotifyWARNTitle", { fg = colors.yellow })
	set_hl("NotifyINFOBorder", { fg = colors.blue })
	set_hl("NotifyINFOIcon", { fg = colors.blue })
	set_hl("NotifyINFOTitle", { fg = colors.blue })
	set_hl("NotifyDEBUGBorder", { fg = colors.cyan })
	set_hl("NotifyDEBUGIcon", { fg = colors.cyan })
	set_hl("NotifyDEBUGTitle", { fg = colors.cyan })
	set_hl("NotifyTRACEBorder", { fg = colors.magenta })
	set_hl("NotifyTRACEIcon", { fg = colors.magenta })
	set_hl("NotifyTRACETitle", { fg = colors.magenta })
	
	-- Gitsigns highlights
	set_hl("GitSignsAdd", { fg = colors.green })
	set_hl("GitSignsAddLn", { bg = "#e8f5e9" })
	set_hl("GitSignsAddNr", { fg = colors.green })
	set_hl("GitSignsChange", { fg = colors.yellow })
	set_hl("GitSignsChangeLn", { bg = "#e3f2fd" })
	set_hl("GitSignsChangeNr", { fg = colors.yellow })
	set_hl("GitSignsDelete", { fg = colors.red })
	set_hl("GitSignsDeleteLn", { bg = "#ffebee" })
	set_hl("GitSignsDeleteNr", { fg = colors.red })
	set_hl("GitSignsTopdelete", { fg = colors.red })
	set_hl("GitSignsChangedelete", { fg = colors.yellow })
	set_hl("GitSignsUntracked", { fg = colors.cyan })
	
	-- Trouble highlights
	set_hl("TroubleText", { fg = colors.fg })
	set_hl("TroubleCount", { fg = colors.accent, bg = colors.light_bg })
	set_hl("TroubleNormal", { fg = colors.fg, bg = colors.dark_bg })
	
	-- Lazy.nvim highlights
	set_hl("LazyButton", { bg = colors.light_bg })
	set_hl("LazyButtonActive", { bg = colors.accent, fg = colors.bg })
	set_hl("LazyComment", { fg = colors.comment })
	set_hl("LazyCommit", { fg = colors.green })
	set_hl("LazyCommitIssue", { fg = colors.red })
	set_hl("LazyCommitScope", { fg = colors.yellow })
	set_hl("LazyCommitType", { fg = colors.blue })
	set_hl("LazyDir", { fg = colors.blue })
	set_hl("LazyH1", { fg = colors.bg, bg = colors.accent, bold = true })
	set_hl("LazyH2", { fg = colors.accent, bold = true })
	set_hl("LazyProp", { fg = colors.cyan })
	set_hl("LazyReasonCmd", { fg = colors.yellow })
	set_hl("LazyReasonEvent", { fg = colors.cyan })
	set_hl("LazyReasonFt", { fg = colors.magenta })
	set_hl("LazyReasonImport", { fg = colors.blue })
	set_hl("LazyReasonKeys", { fg = colors.red })
	set_hl("LazyReasonPlugin", { fg = colors.green })
	set_hl("LazyReasonRuntime", { fg = colors.blue })
	set_hl("LazyReasonSource", { fg = colors.cyan })
	set_hl("LazyReasonStart", { fg = colors.accent })
	set_hl("LazySpecial", { fg = colors.accent })
	set_hl("LazyTaskError", { fg = colors.red })
	set_hl("LazyTaskOutput", { fg = colors.dimmed })
	set_hl("LazyUrl", { fg = colors.blue, underline = true })
	set_hl("LazyValue", { fg = colors.magenta })
	set_hl("LazyProgressDone", { fg = colors.accent })
	set_hl("LazyProgressTodo", { fg = colors.line_nr })
	
	-- Mason highlights
	set_hl("MasonHeader", { fg = colors.bg, bg = colors.accent, bold = true })
	set_hl("MasonHeaderSecondary", { fg = colors.bg, bg = colors.blue, bold = true })
	set_hl("MasonHighlight", { fg = colors.accent })
	set_hl("MasonHighlightBlock", { fg = colors.bg, bg = colors.accent })
	set_hl("MasonHighlightBlockBold", { fg = colors.bg, bg = colors.accent, bold = true })
	set_hl("MasonHighlightSecondary", { fg = colors.blue })
	set_hl("MasonHighlightBlockSecondary", { fg = colors.bg, bg = colors.blue })
	set_hl("MasonHighlightBlockBoldSecondary", { fg = colors.bg, bg = colors.blue, bold = true })
	set_hl("MasonMuted", { fg = colors.dimmed })
	set_hl("MasonMutedBlock", { fg = colors.fg, bg = colors.dimmed })
	set_hl("MasonMutedBlockBold", { fg = colors.fg, bg = colors.dimmed, bold = true })
	set_hl("MasonNormal", { fg = colors.fg, bg = colors.dark_bg })
end

-- Auto-apply when loaded
M.setup()

return M
