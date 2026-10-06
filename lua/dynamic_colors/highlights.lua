--- Neovim highlight groups expressed as semantic relationships to the palette.
---
--- Nothing in here is a fixed color: every value comes from the palette `p`
--- (loaded from the color file) or is derived from it with dynamic_colors.color.
local color = require("dynamic_colors.color")

local M = {}

local COLOR_KEYS = { "fg", "bg", "sp" }

--- Set a highlight group. String colors are normalized to "#rrggbb" since
--- nvim_set_hl() does not understand short or alpha hex forms; integers pass through.
local function set(name, opts)
    for _, key in ipairs(COLOR_KEYS) do
        if type(opts[key]) == "string" then
            opts[key] = color.to_hex(opts[key])
        end
    end

    vim.api.nvim_set_hl(0, name, opts)
end

local function link(name, target)
    vim.api.nvim_set_hl(0, name, { link = target })
end

--- Turn { fg = "primary_1", italic = true } into { fg = p.primary_1, italic = true }.
local function resolve(p, name, spec)
    local opts = {}
    for key, value in pairs(spec) do
        opts[key] = value
    end

    for _, key in ipairs(COLOR_KEYS) do
        local palette_name = spec[key]
        if palette_name ~= nil then
            if p[palette_name] == nil then
                error(string.format("DynamicColors: highlight '%s' refers to unknown palette color '%s'", name, palette_name), 0)
            end
            opts[key] = p[palette_name]
        end
    end

    return opts
end

--- Apply a table of `group = spec`, where spec is either a palette-name table
--- or a string naming the group to link to.
local function apply_table(p, groups)
    for name, spec in pairs(groups) do
        if type(spec) == "string" then
            link(name, spec)
        else
            set(name, resolve(p, name, spec))
        end
    end
end

-- Mappings ------------------------------------------------------------------

-- Slots alternate between the families in order of how common each kind of
-- token is, so neighbouring code gets different hues:
--   primary_1 functions     complement_1 keywords
--   primary_2 strings       complement_2 types
--   primary_3 constants     complement_3 preprocessor
--   primary_4 special       complement_4 builtins
--   primary_5 properties    complement_5 parameters
--   primary_6 modules       complement_6 constructors
local syntax = {
    Comment = { fg = "foreground_muted", italic = true },

    Constant = { fg = "primary_3" },
    String = { fg = "primary_2" },
    Character = { fg = "primary_2" },
    Number = { fg = "primary_3" },
    Boolean = { fg = "primary_3" },
    Float = { fg = "primary_3" },

    Identifier = { fg = "foreground" },
    Function = { fg = "primary_1" },

    Statement = { fg = "complement_1" },
    Conditional = { fg = "complement_1" },
    Repeat = { fg = "complement_1" },
    Label = { fg = "complement_1" },
    Operator = { fg = "foreground_muted" },
    Keyword = { fg = "complement_1" },
    Exception = { fg = "complement_1" },

    PreProc = { fg = "complement_3" },
    Include = { fg = "complement_3" },
    Define = { fg = "complement_3" },
    Macro = { fg = "complement_3" },
    PreCondit = { fg = "complement_3" },

    Type = { fg = "complement_2" },
    StorageClass = { fg = "complement_2" },
    Structure = { fg = "complement_2" },
    Typedef = { fg = "complement_2" },

    Special = { fg = "primary_4" },
    SpecialChar = { fg = "primary_4" },
    Tag = { fg = "primary_1" },
    Delimiter = { fg = "foreground_muted" },
    SpecialComment = { fg = "foreground_muted", bold = true },
    Debug = { fg = "complement_1" },

    Underlined = { fg = "primary_1", underline = true },
    Ignore = { fg = "foreground_dim" },
    Error = { fg = "error", bold = true },
    Todo = { fg = "accent_fg", bg = "accent", bold = true },
}

-- Strings link to another group; tables are palette specs for real differences.
local treesitter = {
    ["@comment"] = "Comment",
    ["@comment.todo"] = "Todo",
    ["@comment.note"] = { fg = "hint", bold = true },
    ["@comment.warning"] = { fg = "warning", bold = true },
    ["@comment.error"] = { fg = "error", bold = true },

    ["@string"] = "String",
    ["@string.escape"] = "SpecialChar",
    ["@string.regexp"] = "SpecialChar",
    ["@string.special"] = "Special",
    ["@character"] = "Character",

    ["@number"] = "Number",
    ["@number.float"] = "Float",
    ["@boolean"] = "Boolean",

    ["@constant"] = "Constant",
    ["@constant.builtin"] = { fg = "complement_4", italic = true },
    ["@constant.macro"] = "Macro",

    ["@module"] = { fg = "primary_6" },
    ["@label"] = "Label",

    -- ["@variable"] = "Identifier",
    ["@variable"] = "Operator",
    ["@variable.builtin"] = { fg = "complement_4", italic = true },
    ["@variable.parameter"] = { fg = "complement_5", italic = true },
    ["@variable.member"] = "@property",
    ["@property"] = { fg = "primary_5" },

    ["@function"] = "Function",
    ["@function.call"] = "Function",
    ["@function.builtin"] = { fg = "complement_4", italic = true },
    ["@function.method"] = "Function",
    ["@function.method.call"] = "Function",
    ["@function.macro"] = "Macro",
    ["@constructor"] = { fg = "complement_6" },

    ["@keyword"] = "Keyword",
    ["@keyword.function"] = "Keyword",
    ["@keyword.return"] = { fg = "complement_1", bold = true },
    ["@keyword.operator"] = "Operator",
    ["@keyword.import"] = "Include",
    ["@keyword.conditional"] = "Conditional",
    ["@keyword.repeat"] = "Repeat",
    ["@keyword.exception"] = "Exception",
    ["@keyword.directive"] = "PreProc",
    ["@keyword.modifier"] = "StorageClass",
    ["@keyword.type"] = "Structure",

    ["@operator"] = "Operator",

    ["@type"] = "Type",
    ["@type.builtin"] = { fg = "complement_4", italic = true },
    ["@type.definition"] = "Typedef",
    ["@attribute"] = "Macro",

    ["@punctuation.delimiter"] = "Delimiter",
    ["@punctuation.bracket"] = "Delimiter",
    ["@punctuation.special"] = "Special",

    ["@tag"] = "Tag",
    ["@tag.builtin"] = "Tag",
    ["@tag.attribute"] = { fg = "primary_5" },
    ["@tag.delimiter"] = "Delimiter",

    ["@markup.heading"] = "Title",
    ["@markup.strong"] = { bold = true },
    ["@markup.italic"] = { italic = true },
    ["@markup.strikethrough"] = { strikethrough = true },
    ["@markup.underline"] = { underline = true },
    ["@markup.quote"] = "Comment",
    ["@markup.raw"] = "String",
    ["@markup.list"] = "Special",
    ["@markup.link"] = "Underlined",
    ["@markup.link.url"] = "Underlined",
    ["@markup.link.label"] = "Special",

    ["@diff.plus"] = "Added",
    ["@diff.minus"] = "Removed",
    ["@diff.delta"] = "Changed",
}

-- Groups --------------------------------------------------------------------

--- `editor_bg` is nil when the background is transparent.
local function apply_editor(p, editor_bg)
    set("Normal", { fg = p.foreground, bg = editor_bg })
    link("NormalNC", "Normal")
    set("NormalFloat", { fg = p.foreground, bg = p.background_alt })
    set("FloatBorder", { fg = p.border, bg = p.background_alt })
    set("FloatTitle", { fg = p.accent, bg = p.background_alt, bold = true })

    set("Cursor", { fg = p.background, bg = p.foreground })
    link("lCursor", "Cursor")
    link("CursorIM", "Cursor")
    set("CursorLine", { bg = p.background_alt })
    link("CursorColumn", "CursorLine")
    set("ColorColumn", { bg = editor_bg and p.background_alt })

    set("LineNr", { fg = p.foreground_dim })
    set("CursorLineNr", { fg = p.accent, bold = true })
    set("SignColumn", { fg = p.foreground_dim })
    set("FoldColumn", { fg = p.foreground_dim })
    set("Folded", { fg = p.foreground_muted, bg = p.background_alt, italic = true })

    set("WinSeparator", { fg = p.border })
    link("VertSplit", "WinSeparator")

    set("Visual", { bg = p.selection })
    link("VisualNOS", "Visual")

    set("EndOfBuffer", { fg = p.foreground_dim })
    set("NonText", { fg = p.foreground_dim })
    set("Whitespace", { fg = p.foreground_dim })
    set("SpecialKey", { fg = p.foreground_dim })
    set("Conceal", { fg = p.foreground_muted })

    set("Directory", { fg = p.primary_1 })
    set("Title", { fg = p.accent, bold = true })
    set("Question", { fg = p.primary_2 })
    set("MoreMsg", { fg = p.primary_2 })
    set("ModeMsg", { fg = p.foreground, bold = true })
    set("ErrorMsg", { fg = p.error, bold = true })
    set("WarningMsg", { fg = p.warning })
    set("OkMsg", { fg = p.success })
    set("QuickFixLine", { bg = p.selection, bold = true })
end

local function apply_syntax(p)
    apply_table(p, syntax)
end

local function apply_treesitter(p)
    apply_table(p, treesitter)
end

local function apply_diagnostics(p)
    local levels = {
        Error = p.error,
        Warn = p.warning,
        Info = p.info,
        Hint = p.hint,
        Ok = p.success,
    }

    for level, fg in pairs(levels) do
        set("Diagnostic" .. level, { fg = fg })
        set("DiagnosticUnderline" .. level, { undercurl = true, sp = fg })
        set("DiagnosticVirtualText" .. level, { fg = fg, bg = color.blend(p.background, fg, 0.1) })
    end

    set("DiagnosticUnnecessary", { fg = p.foreground_dim })
    set("DiagnosticDeprecated", { strikethrough = true, sp = p.foreground_muted })
end

local function apply_completion(p)
    set("Pmenu", { fg = p.foreground, bg = p.background_alt })
    set("PmenuSel", { fg = p.accent_fg, bg = p.accent, bold = true })
    set("PmenuSbar", { bg = p.surface })
    set("PmenuThumb", { bg = p.foreground_dim })
    set("PmenuMatch", { fg = p.accent, bold = true })
    set("PmenuMatchSel", { fg = p.accent_fg, bg = p.accent, bold = true, underline = true })
    set("PmenuKind", { fg = p.foreground_muted, bg = p.background_alt })
    set("PmenuExtra", { fg = p.foreground_muted, bg = p.background_alt })
    set("ComplMatchIns", { fg = p.foreground_muted })
    link("WildMenu", "PmenuSel")
end

local function apply_statusline(p, transparent)
    transparent = transparent or false
    set("StatusLine", transparent and { fg = "#FFFFFF", bg = nil } or { fg = p.foreground, bg = p.surface })
    set("StatusLineNC", transparent and { fg = "#FFFFFF", bg = nil } or { fg = p.foreground_muted, bg = p.background_alt })
end

local function apply_tabline(p, editor_bg)
    set("TabLine", { fg = p.foreground_muted, bg = editor_bg and p.background_alt })
    set("TabLineFill", { bg = editor_bg })
    set("TabLineSel", { fg = p.accent_fg, bg = p.accent, bold = true })
end

local function apply_winbar(p, editor_bg)
    set("WinBar", { fg = p.foreground, bg = editor_bg, bold = true })
    set("WinBarNC", { fg = p.foreground_muted, bg = editor_bg })
end

local function apply_search(p)
    set("Search", { fg = color.contrast_color(p.primary_2), bg = p.primary_2 })
    set("IncSearch", { fg = p.accent_fg, bg = p.accent, bold = true })
    link("CurSearch", "IncSearch")
    set("Substitute", { fg = color.contrast_color(p.complement_1), bg = p.complement_1 })
    set("MatchParen", { fg = p.accent, bg = p.surface, bold = true })
end

local function apply_diff(p)
    set("DiffAdd", { bg = p.diff_add })
    set("DiffChange", { bg = p.diff_change })
    set("DiffDelete", { fg = p.error, bg = p.diff_delete })
    set("DiffText", { bg = p.diff_text, bold = true })

    set("Added", { fg = p.success })
    set("Changed", { fg = p.info })
    set("Removed", { fg = p.error })
end

local function apply_spelling(p)
    set("SpellBad", { undercurl = true, sp = p.error })
    set("SpellCap", { undercurl = true, sp = p.warning })
    set("SpellRare", { undercurl = true, sp = p.hint })
    set("SpellLocal", { undercurl = true, sp = p.info })
end

local function apply_special(p)
    set("LspReferenceText", { bg = p.surface })
    link("LspReferenceRead", "LspReferenceText")
    set("LspReferenceWrite", { bg = p.surface, underline = true, sp = p.accent })
    set("LspInlayHint", { fg = p.foreground_dim, italic = true })
    set("LspCodeLens", { fg = p.foreground_dim })
    set("LspSignatureActiveParameter", { fg = p.accent, bold = true, underline = true })
    link("SnippetTabstop", "Visual")
end

--- Terminal ANSI slots filled from palette roles (there are no fixed hues).
--- Neovim wants terminal colors as "#rrggbb" strings.
local function apply_terminal(p)
    local slots = {
        p.surface, -- 0 black
        p.complement_1, -- 1 red
        p.primary_2, -- 2 green
        p.complement_2, -- 3 yellow
        p.primary_1, -- 4 blue
        p.complement_3, -- 5 magenta
        p.primary_3, -- 6 cyan
        p.foreground_muted, -- 7 white
    }

    for index, value in ipairs(slots) do
        vim.g["terminal_color_" .. (index - 1)] = color.to_hex(value)
        vim.g["terminal_color_" .. (index + 7)] = color.blend(value, p.foreground, 0.25)
    end
end

--- Apply every highlight group and the terminal palette.
---
--- With `opts.transparent` the editor background is left unpainted so the
--- terminal (and any image behind it) shows through; floats, menus, bars and
--- selections keep their fills.
---@param p table<string, string|integer> palette from dynamic_colors.palette.load()
---@param opts? { transparent?: boolean }
function M.apply(p, opts)
    opts = opts or {}
    local editor_bg = not opts.transparent and p.background or nil

    apply_editor(p, editor_bg)
    apply_syntax(p)
    apply_treesitter(p)
    apply_diagnostics(p)
    apply_completion(p)
    apply_statusline(p, opts.transparent)
    apply_tabline(p, editor_bg)
    apply_winbar(p, editor_bg)
    apply_search(p)
    apply_diff(p)
    apply_spelling(p)
    apply_special(p)
    apply_terminal(p)
end

return M
