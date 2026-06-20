-- TODO: fix
--    - dap
--    - proper lsp

vim.opt.termguicolors = true
vim.cmd.colorscheme("unokai")
-- :lua print('vim.cmd.colorscheme("'..vim.g.colors_name..'")')

require("utils")
require("options")
require("keymaps")
require("autocmds")
require("float_terminal")
require("colorscheme")

vim.keymap.set('n', '<leader>A', vim.utils.print_current_char_code, { desc = 'Code of char under cursor', noremap = true, silent = true })

local statusline = require("statusline")
statusline.setup()
statusline.enable()

local cmbed = require("combed")
vim.keymap.set({ 'n' }, '<M-X>', cmbed.executeCommandInBuffer(false), { desc = 'Execute command in place' })
vim.keymap.set({ 'n' }, '<M-x>', cmbed.executeCommandInBuffer(true), { desc = 'Execute command in place and replace' })

local c_utils = require("c_utils")
vim.api.nvim_create_user_command('CHeaderThing', c_utils.generate_c_header_only_preprocs, { desc = 'Generate C header guard machinery' })
vim.api.nvim_create_user_command('PreprocessC', c_utils.preprocessCFile, { desc = 'Preprocess C File' })
vim.keymap.set({ 'n' }, '<leader>lh', c_utils.generate_c_header_only_preprocs, { desc = 'Generate C header guard machinery' })
vim.keymap.set({ 'n' }, '<leader>lp', c_utils.preprocessCFile, { desc = 'Preprocess C File' })

local function set_transparent() -- set UI component to transparent
  local groups = {
    "Normal",
    "NormalNC",
    "EndOfBuffer",
    "NormalFloat",
    "FloatBorder",
    "SignColumn",
    "StatusLine",
    "StatusLineNC",
    "TabLine",
    -- "TabLineFill",
    -- "TabLineSel",
    "ColorColumn",
  }
  for _, g in ipairs(groups) do vim.api.nvim_set_hl(0, g, { bg = "none" }) end
  vim.api.nvim_set_hl(0, "TabLineFill", { bg = "none", fg = "#767676" })
end

vim.keymap.set("n", "<leader>.", function()
  if vim.g.transparent then
    vim.cmd.colorscheme(vim.g.colors_name)
    vim.g.transparent = false
  else
    set_transparent()
    vim.g.transparent = true
  end
end, { desc = "Toggle background transparency", silent = true, noremap = true })

set_transparent()


local plugins = {
  require("plugins.plenary"),

  require("plugins.icons"),
  require("plugins.colorizer"),
  require("plugins.render-markdown"),
  require("plugins.todo-comments"),

  require("plugins.whichkey"),

  require("plugins.mini"),
  require("plugins.fzf"),
  require("plugins.undotree"),
  require("plugins.ufo"),
  require("plugins.aerial"),
  require("plugins.fyler"),
  require("plugins.compile-mode"),
  require("plugins.gitsigns"),

  require("plugins.neogen"),

  require("plugins.alpha"),

  require("plugins.neogit"),

  require("plugins.hover"),

  require("plugins.cmp"),
  require("plugins.dap"),
  require("plugins.treesitter"),
  require("plugins.lsp"),
}

vim.pack.packit(plugins)


vim.keymap.hint("<leader>b", "Buffer")
vim.keymap.hint("<leader>L", "Source")
vim.keymap.hint("<leader>t", "Tab")

vim.keymap.hint("<leader>a", "Aerial")
vim.keymap.hint("<leader>c", "Compile")
vim.keymap.hint("<leader>f", "Find")
vim.keymap.hint("<leader>H", "GitSigns")
vim.keymap.hint("<leader>cn", "Next")
vim.keymap.hint("<leader>cp", "Previous")

vim.keymap.hint("<leader>g", "Goto")
vim.keymap.hint("<leader>w", "Workspace")

vim.keymap.hint("<leader>l", "LSP")
vim.keymap.hint("<leader>l/", "Twoslash Queries")
vim.keymap.hint("<leader>ls", "Split horizontaly and...")
vim.keymap.hint("<leader>lv", "Split verticaly and...")

-- vim.keymap.set({'n', 'i'}, '<c-j>', function() vim.cmd("Inspect") end, {})

