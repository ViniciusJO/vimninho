local M = { }

M.cmdline_content = ""

M.modes = {
  ["n"] = "NORMAL",
  ["no"] = "NORMAL",
  ["v"] = "VISUAL",
  ["V"] = "VISUAL LINE",
  [""] = "VISUAL BLOCK",
  ["s"] = "SELECT",
  ["S"] = "SELECT LINE",
  [""] = "SELECT BLOCK",
  ["i"] = "INSERT",
  ["ic"] = "INSERT",
  ["R"] = "REPLACE",
  ["Rv"] = "VISUAL REPLACE",
  ["c"] = "COMMAND",
  ["cv"] = "VIM EX",
  ["ce"] = "EX",
  ["r"] = "PROMPT",
  ["rm"] = "MOAR",
  ["r?"] = "CONFIRM",
  ["!"] = "SHELL",
  ["t"] = "TERMINAL",
  ["nt"] = "UNFOCUSED TERMINAL",
}

function M.mode()
  local current_mode = vim.api.nvim_get_mode().mode
  return string.format(" %s ", M.modes[current_mode]):upper()
end

function M.update_mode_colors()
  local current_mode = vim.api.nvim_get_mode().mode
  local mode_color = "%#StatusLineAccent#"
  if current_mode == "n" then
    mode_color = "%#StatuslineAccent#"
  elseif current_mode == "i" or current_mode == "ic" then
    mode_color = "%#StatuslineInsertAccent#"
  elseif current_mode == "v" or current_mode == "V" or current_mode == "" then
    mode_color = "%#StatuslineVisualAccent#"
  elseif current_mode == "R" then
    mode_color = "%#StatuslineReplaceAccent#"
  elseif current_mode == "c" then
    mode_color = "%#StatuslineCmdLineAccent#"
  elseif current_mode == "t" then
    mode_color = "%#StatuslineTerminalAccent#"
  elseif current_mode == "nt" then
    mode_color = "%#StatuslineTerminalAccent#"
  end
  return mode_color
end

function M.filepath()
  if M.cmdline_content == "" then
    local fpath = vim.fn.fnamemodify(vim.fn.expand "%", ":~:.:h")
    if fpath == "" or fpath == "." then return " " end
    return string.format(" %%<%s/", fpath)
  else return ""
  end
end

function M.filename()
  if M.cmdline_content == "" then
    local fname = vim.fn.expand "%:t"
    if fname == "" then return "" end
    return fname .. " %m "
  else return ""
  end
end

function M.execute(command)
  local handle = io.popen(command)
  if not handle then error("Command " .. string(command) .. " error", 1) end
  local result = handle:read("*a")
  handle:close()
  return result
end

function M.git_branch()
  if M.cmdline_content == "" then
    local branch = M.execute(string.format("git -C %s rev-parse --abbrev-ref HEAD 2> /dev/null || echo ''", vim.fn.expand("%:h")))
    return branch:gsub("^%s*(.-)%s*$", "%1") == "" and "" or branch:gsub("^%s*(.-)%s*$", "<< %1>>")
  else return ""
  end
end

function M.lsp()
  local count = {}
  local levels = {
    errors = vim.diagnostic.ERROR, -- ERROR
    warnings = vim.diagnostic.WARN, -- WARN
    info = vim.diagnostic.INFO, -- INFO
    hints = vim.diagnostic.HINT, -- HINT
  }

  for k, level in pairs(levels) do
    count[k] = vim.tbl_count(vim.diagnostic.get(0, { severity = level }))
  end

  local errors = ""
  local warnings = ""
  local hints = ""
  local info = ""

  if count["errors"] ~= nil and count["errors"] ~= 0 then
    errors = " %#LspDiagnosticsSignError# " .. count["errors"]
  end
  if count["warnings"] ~= nil and count["warnings"] ~= 0 then
    warnings = " %#LspDiagnosticsSignWarning# " .. count["warnings"]
  end
  if count["hints"] ~= nil and count["hints"] ~= 0 then
    hints = " %#LspDiagnosticsSignHint# " .. count["hints"]
  end
  if count["info"] ~= nil and count["info"] ~= 0 then
    info = " %#LspDiagnosticsSignInformation# " .. count["info"]
  end

  return errors .. warnings .. hints .. info .. "%#Normal#"
end

function M.filetype()
  local is_there_icons_plugin = pcall(require, "nvim-web-devicons")
  local icon, color = nil, nil
  if is_there_icons_plugin then
    icon, color = require('nvim-web-devicons').get_icon_color(M.filename(), vim.bo.filetype)
  end
  vim.api.nvim_set_hl(0, 'StatusLineFileType', { foreground = color or "#FFFFFF", background = 'none', bold = false })
  return string.format(" %%#StatusLineFileType#%s %s %%#Normal#", icon or "", vim.bo.filetype)
end

function M.lineinfo()
  if vim.bo.filetype == "alpha" then return ""; end
  return " %P %4.l:%3.c "
end

-- local function commandstr()
--   if cmdline_content ~= "" then
--     return " " .. cmdline_content
--   else
--     return ""
--   end
-- end

-- Autocommand for when command line is entered
vim.api.nvim_create_autocmd({ "BufEnter", "ModeChanged", "CmdlineEnter", "CmdlineChanged", "CmdlineLeave" }, {
  callback = function() vim.cmd.redrawstatus() end,
})

function M.get_buf_desc()
  -- if vim.bo.filetype == "c" then return " " .. vim.fn.getcmdtype() .. (M.cmdline_content .. " ")
  -- if vim.bo.filetype == "c" then return " " .. vim.fn.getcmdtype() .. vim.fn.getcmdline() .. " " end
  if vim.bo.buftype == "terminal" then return " ▶_/ Term" end
  return M.filepath() .. M.filename()
end

function M.get(_)
  if vim.bo.filetype:match("fyler") then return "%#StatusLineNC#   Fyler" end
  return table.concat {
    "%#Statusline#",
    M.update_mode_colors(),
    M.mode(),
    "%#Normal#",
    M.get_buf_desc(),

    "%=%#WarningMsg#",
    M.git_branch(),
    "%=%#Normal#",

    M.lsp(),
    " ",
    M.filetype(),
    "%#StatusLineExtra#",
    M.lineinfo(),
  }
end

function M.enable(_)
  if M.default_bkp then return end
  M.default_bkp = vim.o.statusline
  vim.o.statusline = "%!v:lua.Statusline.get()"
end

function M.enable_alt(_)
  if M.default_bkp then return end
  M.default_bkp = vim.o.statusline
  vim.o.statusline = "%t%M %S%=%y %(%L lines %l:%c [%3.p%%]%)"
end

function M.disable(_)
  vim.o.statusline = M.default_bkp
  M.default_bkp = nil
end

function M.check(_)
  vim.health.ok("Statusline ok")
end

function M.setup(_)
  vim.health.start("Statusline")
  vim.health.ok("Statusline ok")
end

--statusline
-- vim.api.nvim_set_hl(0, 'StatusType',{ foreground='#1d2021', background='#b16286', bold=false })
-- vim.api.nvim_set_hl(0, 'StatusFile',{ foreground='#1d2021', background='#fabd2f', bold=false })
-- vim.api.nvim_set_hl(0, 'StatusModified',{ foreground='#d3869b', background='#1d2021', bold=false })
-- vim.api.nvim_set_hl(0, 'StatusBuffer',{ foreground='#1d2021', background='#98971a', bold=false })
-- vim.api.nvim_set_hl(0, 'StatusLocation',{ foreground='#1d2021', background='#458588', bold=false })
-- vim.api.nvim_set_hl(0, 'StatusPercent',{ foreground='#ebdbb2', background='#1d2021', bold=false })
-- vim.api.nvim_set_hl(0, 'StatusNorm',{ foreground='#FFFFFF', background='none', bold=false })
vim.api.nvim_set_hl(0, 'StatusType', { foreground = '#1d2021', background = '#b16286', bold = false })
vim.api.nvim_set_hl(0, 'StatusFile', { foreground = '#1d2021', background = '#fabd2f', bold = false })
vim.api.nvim_set_hl(0, 'StatusModified', { foreground = '#d3869b', background = '#1d2021', bold = false })
vim.api.nvim_set_hl(0, 'StatusBuffer', { foreground = '#1d2021', background = '#98971a', bold = false })
vim.api.nvim_set_hl(0, 'StatusLocation', { foreground = '#1d2021', background = '#458588', bold = false })
vim.api.nvim_set_hl(0, 'StatusPercent', { foreground = '#ebdbb2', background = '#1d2021', bold = false })
vim.api.nvim_set_hl(0, 'StatusNorm', { foreground = '#FFFFFF', background = 'none', bold = false })

local function getColor(group) return vim.api.nvim_get_hl_by_name(group, true); end

vim.api.nvim_set_hl(0, 'StatusLineAccent', { foreground = '#000000', background = '#FFFFFF', bold = false })
vim.api.nvim_set_hl(0, 'StatuslineAccent',
  { foreground = '#000000', background = getColor('IncSearch').background, bold = false })
vim.api.nvim_set_hl(0, 'StatuslineInsertAccent',
  { foreground = '#000000', background = getColor('WarningMsg').foreground, bold = false })
vim.api.nvim_set_hl(0, 'StatuslineVisualAccent', getColor('Substitute'))
vim.api.nvim_set_hl(0, 'StatuslineCmdLineAccent', getColor('WildMenu'))
vim.api.nvim_set_hl(0, 'StatuslineTerminalAccent', getColor('DiffChange'))
vim.api.nvim_set_hl(0, 'StatuslineReplaceAccent', getColor('DiffText'))

-- vim.api.nvim_set_hl(0, 'StatusLineAccent',{ foreground='#000000', background='#FFFFFF', bold=false })
-- vim.api.nvim_set_hl(0, 'StatuslineAccent',{ foreground='#000000', background='#33bb77', bold=false })
-- vim.api.nvim_set_hl(0, 'StatuslineInsertAccent',{ foreground='#000000', background='#00AF21', bold=false })
-- vim.api.nvim_set_hl(0, 'StatuslineVisualAccent',{ foreground='#000000', background='#FF4321', bold=false })
-- vim.api.nvim_set_hl(0, 'StatuslineReplaceAccent',{ foreground='#000000', background='#FFFFFF', bold=false })
-- vim.api.nvim_set_hl(0, 'StatuslineCmdLineAccent',{ foreground='#000000', background='#3377EB', bold=false })
-- vim.api.nvim_set_hl(0, 'StatuslineTerminalAccent',{ foreground='#000000', background='#1274AF', bold=false })

vim.api.nvim_set_hl(0, 'StatusGit', { foreground = '#AA23FF', background = 'none', bold = false })

vim.api.nvim_set_hl(0, 'LspDiagnosticsSignError', { foreground = '#FF4321', background = 'none', bold = false })
vim.api.nvim_set_hl(0, 'LspDiagnosticsSignWarning', { foreground = '#AA8710', background = 'none', bold = false })
vim.api.nvim_set_hl(0, 'LspDiagnosticsSignHint', { foreground = '#1274AF', background = 'none', bold = false })
vim.api.nvim_set_hl(0, 'LspDiagnosticsSignInformation', { foreground = '#00AF21', background = 'none', bold = false })


-- -- Autocommand for when command line is changed
-- vim.api.nvim_create_autocmd({ "CmdlineChanged" }, {
--   callback = function()
--     -- M.cmdline_content = vim.fn.getcmdline()
--     vim.cmd.redrawstatus()
--   end,
-- })
--
-- -- Autocommand for when command line is exited
-- vim.api.nvim_create_autocmd({ "CmdlineLeave" }, {
--   callback = function()
--     -- M.cmdline_content = ""
--     vim.cmd.redrawstatus()
--   end,
-- })

_G.Statusline = M

return M
