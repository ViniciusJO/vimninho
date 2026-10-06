--- Dynamic colorscheme driven by a color file given to setup().
---
---   local dynamic_colors = require("dynamic_colors")
---   dynamic_colors.setup({ path = "~/.cache/juiced.color", transparent = true })
---   vim.cmd.colorscheme("dynamic_colors")         -- runs colors/dynamic_colors.lua -> apply()
---
---   dynamic_colors.apply()   -- read the file and apply highlights
---   dynamic_colors.reload()  -- same, then notify ColorScheme listeners
---
--- The color file is watched only while this colorscheme is active: apply()
--- starts the watcher and loading any other colorscheme stops it.
local color = require("dynamic_colors.color")
local highlights = require("dynamic_colors.highlights")
local palette = require("dynamic_colors.palette")

local M = {}

local NAME = "dynamic_colors"

--- Writers often touch the file several times in a row; wait for them to settle.
local DEBOUNCE_MS = 100

local uv = vim.uv or vim.loop

--- Both exist exactly while the color file is being watched.
local watcher = nil
local debounce_timer = nil

---@class dynamic_colors.Options
---@field path string|nil color file, unexpanded (as given to setup())
---@field transparent boolean leave the editor background unpainted

---@type dynamic_colors.Options
local options = {
    path = nil,
    transparent = false,
}

local function require_path()
    if not options.path then
        error('DynamicColors: no color file set, call require("dynamic_colors").setup({ path = ... }) first', 0)
    end

    return options.path
end

local function on_file_changed()
    -- A reload may already be queued when the watcher is stopped; drop it.
    if not watcher then
        return
    end

    local ok, err = pcall(M.reload)
    if not ok then
        vim.notify(tostring(err), vim.log.levels.ERROR)
    end
end

--- Start watching the color file. Safe to call repeatedly.
---
--- The parent directory is watched instead of the file itself, so files that
--- are replaced (written to a temp file, then renamed) are still picked up.
function M.watch()
    if watcher or not options.path then
        return
    end

    local path = vim.fn.expand(options.path)
    local directory = vim.fn.fnamemodify(path, ":h")
    local filename = vim.fn.fnamemodify(path, ":t")

    local handle = uv.new_fs_event()
    local timer = uv.new_timer()
    if not handle or not timer then
        vim.notify("DynamicColors: cannot create file watcher", vim.log.levels.WARN)
        return
    end

    local ok, err = handle:start(directory, {}, function(watch_err, changed)
        if watch_err or changed ~= filename then
            return
        end

        timer:stop()
        timer:start(DEBOUNCE_MS, 0, vim.schedule_wrap(on_file_changed))
    end)

    if not ok then
        handle:close()
        timer:close()
        vim.notify(
            string.format("DynamicColors: cannot watch %s for changes\nreason: %s", directory, tostring(err)),
            vim.log.levels.WARN
        )
        return
    end

    watcher = handle
    debounce_timer = timer
end

--- Stop watching the color file.
function M.unwatch()
    if not watcher then
        return
    end

    watcher:stop()
    watcher:close()
    debounce_timer:stop()
    debounce_timer:close()
    watcher = nil
    debounce_timer = nil
end

--- True while the color file is being watched.
---@return boolean
function M.is_watching()
    return watcher ~= nil
end

--- Set options and create the :DynamicColorsReload command.
---
--- Does not apply any colors: choose the colorscheme with
--- `vim.cmd.colorscheme("dynamic_colors")` (or any other one).
--- Calling it again updates the options; run :DynamicColorsReload to see them.
---@param opts { path: string, transparent?: boolean }
function M.setup(opts)
    opts = opts or {}

    local path = opts.path or options.path
    if type(path) ~= "string" or path == "" then
        error(string.format("DynamicColors: setup() needs `path` to the color file, got %s", vim.inspect(opts.path)), 2)
    end

    if path ~= options.path then
        options.path = path

        -- Follow the new file if the old one was being watched.
        if watcher then
            M.unwatch()
            M.watch()
        end
    end

    if opts.transparent ~= nil then
        options.transparent = opts.transparent == true
    end

    -- ColorSchemePre fires before any :colorscheme loads, with the new name.
    -- Stopping here (rather than after) also covers schemes that fail to load.
    vim.api.nvim_create_autocmd("ColorSchemePre", {
        group = vim.api.nvim_create_augroup("DynamicColors", { clear = true }),
        desc = "Stop watching the dynamic_colors file when another colorscheme loads",
        callback = function(args)
            if args.match ~= NAME then
                M.unwatch()
            end
        end,
    })

    vim.api.nvim_create_user_command("DynamicColorsReload", function()
        local ok, err = pcall(M.reload)
        if not ok then
            vim.notify(tostring(err), vim.log.levels.ERROR)
        end
    end, { desc = "Reread the color file and reapply the dynamic colorscheme" })
end

--- Flip the `transparent` option and return the new state.
---
--- Reapplies right away when this colorscheme is active; otherwise the new
--- state is used the next time it loads.
---@return boolean transparent
function M.toggle_transparency()
    options.transparent = not options.transparent

    if vim.g.colors_name == NAME then
        M.reload()
    end

    return options.transparent
end

--- Read the color file and apply the whole colorscheme.
---
--- The palette is loaded before anything is cleared, so a broken color file
--- raises an error and leaves the current colors untouched. The watcher is
--- started first (if not running), so fixing a broken file applies the colors
--- automatically.
function M.apply()
    local path = require_path()

    M.watch()

    local p = palette.load(path)

    vim.o.termguicolors = true

    -- Unset first: changing 'background' while colors_name is set re-sources the colorscheme.
    vim.g.colors_name = nil
    vim.o.background = color.is_light(p.background) and "light" or "dark"

    vim.cmd("highlight clear")
    if vim.fn.exists("syntax_on") == 1 then
        vim.cmd("syntax reset")
    end

    highlights.apply(p, { transparent = options.transparent })

    vim.g.colors_name = NAME
end

--- Reread the color file, reapply everything and fire the ColorScheme event so
--- statuslines and other config built on the palette can refresh.
function M.reload()
    M.apply()
    vim.api.nvim_exec_autocmds("ColorScheme", { pattern = NAME, modeline = false })
end

return M
