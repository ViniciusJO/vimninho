vim.opt.termguicolors = true
vim.cmd.colorscheme("unokai")

require("utils")

--vim.print(vim.lsp.protocol.make_client_capabilities())
--vim.print(vim.fn.systemlist("bash -c 'compgen -c git'"))

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
  for _, g in ipairs(groups) do
    vim.api.nvim_set_hl(0, g, { bg = "none" })
  end
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
vim.g.transparent = true

-- ============================================================================
-- OPTIONS
-- ============================================================================

-- Netrw
vim.opt.runtimepath:remove(vim.fn.stdpath('config') .. '/autoload/netrw.vim')
vim.opt.runtimepath:remove(vim.fn.stdpath('config') .. '/plugin/netrwPlugin.vim')
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.netrw_banner = 0
vim.g.netrw_browse_split = 4
vim.g.netrw_altv = 1
vim.g.netrw_liststyle = 3

vim.opt.number = true                                     -- line number
vim.opt.relativenumber = true                             -- relative line numbers
vim.opt.cursorline = true                                 -- highlight current line
vim.opt.wrap = false                                      -- do not wrap lines by default
vim.opt.breakindent = true                                -- breakindent
vim.opt.scrolloff = 2                                     -- keep 10 lines above/below cursor
vim.opt.sidescrolloff = 10                                -- keep 10 lines to left/right of cursor

vim.opt.tabstop = 2                                       -- tabwidth
vim.opt.shiftwidth = 2                                    -- indent width
vim.opt.softtabstop = 2                                   -- soft tab stop not tabs on tab/backspace
vim.opt.smarttab = true                                   -- smarttab
vim.opt.expandtab = true                                  -- use spaces instead of tabs
vim.opt.smartindent = true                                -- smart auto-indent
vim.opt.autoindent = true                                 -- copy indent from current line

vim.opt.ignorecase = true                                 -- case insensitive search
vim.opt.smartcase = true                                  -- case sensitive if uppercase in string
vim.opt.hlsearch = true                                   -- highlight search matches
vim.opt.incsearch = true                                  -- show matches as you type

vim.opt.signcolumn = "yes"                                -- always show a sign column
vim.opt.colorcolumn = "100"                               -- show a column at 100 position chars
vim.opt.showmatch = true                                  -- highlights matching brackets
vim.opt.cmdheight = 1                                     -- single line command line
vim.opt.completeopt = "menuone,noinsert,noselect,preview" -- completion options
vim.opt.showmode = false                                  -- do not show the mode, instead have it in statusline
vim.opt.pumheight = 10                                    -- popup menu height
vim.opt.pumblend = 10                                     -- popup menu transparency
vim.opt.winblend = 0                                      -- floating window transparency
vim.opt.conceallevel = 0                                  -- do not hide markup
vim.opt.concealcursor = ""                                -- do not hide cursorline in markup
vim.opt.lazyredraw = true                                 -- do not redraw during macros
vim.opt.synmaxcol = 300                                   -- syntax highlighting limit
vim.opt.fillchars = { eob = " " }                         -- hide "~" on empty lines

local undodir = vim.fn.expand("~/.vim/undodir")
if vim.fn.isdirectory(undodir) == 0 then vim.fn.mkdir(undodir, "p") end

vim.opt.backup = false                  -- do not create a backup file
vim.opt.writebackup = false             -- do not write to a backup file
vim.opt.swapfile = false                -- do not create a swapfile
vim.opt.undofile = true                 -- do create an undo file
vim.opt.undodir = undodir               -- set the undo directory
vim.opt.updatetime = 250                -- faster completion
vim.o.timeout = true
vim.opt.timeoutlen = 300                -- timeout duration
vim.opt.ttimeoutlen = 0                 -- key code timeout
vim.opt.autoread = true                 -- auto-reload changes if outside of neovim
vim.opt.autowrite = false               -- do not auto-save

vim.opt.hidden = true                   -- allow hidden buffers
vim.opt.errorbells = false              -- no error sounds
vim.opt.backspace = "indent,eol,start"  -- better backspace behaviour
vim.opt.autochdir = false               -- do not autochange directories
vim.opt.iskeyword:append("-")           -- include - in words
vim.opt.path:append("**")               -- include subdirs in search
vim.opt.selection = "inclusive"         -- include last char in selection
vim.opt.mouse = "a"                     -- enable mouse support
vim.opt.clipboard:append("unnamedplus") -- use system clipboard
vim.opt.modifiable = true               -- allow buffer modifications
vim.opt.encoding = "utf-8"              -- set encoding

-- vim.opt.guicursor =
-- 	"n-v-c:block,i-ci-ve:block,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175" -- cursor blinking and settings

-- Folding: requires treesitter available at runtime; safe fallback if not
vim.opt.foldmethod = "expr"                          -- use expression for folding
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- use treesitter for folding
vim.opt.foldlevel = 99                               -- start with all folds open
vim.o.foldlevelstart = 99
vim.o.foldenable = true

vim.opt.splitbelow = true              -- horizontal splits go below
vim.opt.splitright = true              -- vertical splits go right

vim.opt.wildmenu = true                -- tab completion
vim.opt.wildmode = "longest:full,full" -- complete longest common match, full completion list, cycle through with Tab
vim.opt.diffopt:append("linematch:60") -- improve diff display
vim.opt.redrawtime = 10000             -- increase neovim redraw tolerance
vim.opt.maxmempattern = 20000          -- increase max memory







-- ============================================================================
-- KEYMAPS
-- ============================================================================
vim.g.mapleader = " "      -- space for leader
vim.g.maplocalleader = " " -- space for localleader

-- Source configs
vim.g.runtimepath = vim.api.nvim_list_runtime_paths()[1]
vim.keymap.set('n', '<leader>r', function() vim.cmd.source(vim.g.runtimepath .. '/init.lua') end,
  { desc = 'Source configs', silent = false, noremap = true })


-- jj go to normal mode
vim.keymap.set({ 'i' }, 'jj', '<esc>')
vim.keymap.set({ 't', 'c' }, 'jj', '<C-\\><C-n>')

-- Keymaps for save and quit
vim.keymap.set('n', '<C-s>', '<cmd>w<cr>', { desc = 'Save buffer to file', silent = true })
vim.keymap.set('n', '<C-q>', '<cmd>q<cr>', { desc = 'Quit window', silent = true })
vim.keymap.set('n', '<C-Q>', '<cmd>q!<cr>', { desc = 'Quit window', silent = true })

-- Copy to systems clipboard
vim.keymap.set('n', 'Y', '"+y', { desc = 'Yank to systems clipboard' });
vim.keymap.set('v', '<C-c>', '"+y', { desc = 'Yank to systems clipboard' });

-- Go to help
vim.keymap.set('n', 'gh', function() vim.cmd('h ' .. vim.fn.expand('<cword>')) end,
  { desc = 'Goto help', noremap = true, silent = true })

local arrow_state = false
vim.keymap.set({ 'n', 't', 'i', 'v' }, '<M-A>', function()
  vim.keymap.set({ 'n', 't', 'i', 'v' }, '<Up>', arrow_state and '<Nop>' or '<Up>', { silent = true })
  vim.keymap.set({ 'n', 't', 'i', 'v' }, '<Down>', arrow_state and '<Nop>' or '<Down>', { silent = true })
  vim.keymap.set({ 'n', 't', 'i', 'v' }, '<Left>', arrow_state and '<Nop>' or '<Left>', { silent = true })
  vim.keymap.set({ 'n', 't', 'i', 'v' }, '<Right>', arrow_state and '<Nop>' or '<Right>', { silent = true })
  arrow_state = not arrow_state
end, { desc = 'Toggle arrow keys', noremap = true, silent = true })

-- better movement in wrapped text
vim.keymap.set("n", "j", function()
  return vim.v.count == 0 and "gj" or "j"
end, { expr = true, silent = true, desc = "Down (wrap-aware)" })
vim.keymap.set("n", "k", function()
  return vim.v.count == 0 and "gk" or "k"
end, { expr = true, silent = true, desc = "Up (wrap-aware)" })

-- Movement on insert mode
vim.keymap.set({ 'i', 't' }, '<C-k>', '<Up>', { noremap = true, silent = true })
vim.keymap.set({ 'i', 't' }, '<C-j>', '<Down>', { noremap = true, silent = true })
vim.keymap.set({ 'i', 't' }, '<C-h>', '<Left>', { noremap = true, silent = true })
vim.keymap.set({ 'i', 't' }, '<C-l>', '<Right>', { noremap = true, silent = true })

vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

vim.keymap.set('n', '<leader>h', '<cmd>set hlsearch!<CR>',
  { noremap = true, silent = true, desc = 'Toggle search highlight' })

vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })

vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Paste without yanking" })
-- vim.keymap.set({ "n", "v" }, "<leader>x", '"_d', { desc = "Delete without yanking" })


vim.keymap.set("n", "<C-J>", "mzJ`z", { desc = "Join lines and keep cursor position" })

-- Toggle options
vim.keymap.set('n', '<M-z>', function() if (vim.o.wrap) then vim.o.wrap = false else vim.o.wrap = true end end,
  { desc = 'Toggle wrap', expr = true })
vim.keymap.set('n', '<M-r>',
  function() if (vim.o.relativenumber) then vim.o.relativenumber = false else vim.o.relativenumber = true end end,
  { desc = 'Toggle relative collumn number', expr = true })

-- Tabs
vim.keymap.set('n', '[t', '<CMD>tabnext<CR>', { desc = 'Go to previous tab' })
vim.keymap.set('n', '[T', '<CMD>tablast<CR>', { desc = 'Go to last tab' })
vim.keymap.set('n', ']t', '<CMD>tabprev<CR>', { desc = 'Go to previous tab' })
vim.keymap.set('n', ']T', '<CMD>tabfirst<CR>', { desc = 'Go to first tab' })
vim.keymap.set('n', '<leader>tn', '<CMD>tabnew<CR>', { desc = 'Tab new' })
vim.keymap.set('n', '<leader>td', '<CMD>tabclose<CR>', { desc = 'Tab close' })

-- Buffers
vim.keymap.set('n', '<leader>bd', '<CMD>bd<CR>', { desc = 'Close Current Buffer', silent = true })
vim.keymap.set('n', '<leader>bn', '<CMD>enew<CR>', { desc = 'Open Blank Buffer', silent = true })

-- Diagnostic
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>dd', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

vim.keymap.set("n", "<leader>le", function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle diagnostics" })

-- Macros
vim.keymap.set('n', 'Q', '@q', { desc = 'Plays macro at q' })
vim.keymap.set('x', 'Q', ':norm @q<CR>', { desc = 'Plays macro at q on each lines selected' })

-- Terminal
vim.keymap.set('n', '<leader>x', '<cmd>split | term<CR>i',
  { noremap = true, silent = true, desc = 'Toggle split terminal' })
vim.keymap.set('n', '<leader>X', '<cmd>vsplit | term<CR>i',
  { noremap = true, silent = true, desc = 'Toggle split terminal [vertcal]' })
vim.keymap.set('t', '<esc><esc>', '<C-\\><C-n>', { noremap = true, silent = true, desc = 'Unfocus terminal' })
vim.keymap.set('t', '<C-w>', '<C-\\><C-n><C-w>', { noremap = true, silent = true, desc = 'Navigate' })

-- Visual Maps
vim.keymap.set("v", "<leader>r", "\"hy:%s/<C-r>h//g<left><left>", { desc = 'Replace all instances of highlighted words' })
vim.keymap.set("v", "<C-s>", "<cmd>sort<CR>", { desc = 'Sort highlighted text' })

-- Quickfix
vim.keymap.set({ 'n', 'v', 't' }, "<leader>q", function()
  for _, win in ipairs(vim.fn.getwininfo()) do
    if win.quickfix == 1 then
      vim.cmd("cclose")
      return
    end
  end
  vim.cmd("cw")
end, { desc = "Toggle quickfix list" })


-- vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
-- vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })

-- vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
-- vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
-- vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
-- vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- vim.keymap.set("n", "<leader>sv", ":vsplit<CR>", { desc = "Split window vertically" })
-- vim.keymap.set("n", "<leader>sh", ":split<CR>", { desc = "Split window horizontally" })


-- vim.keymap.set("n", "<leader>pa", function() -- show file path
-- 	local path = vim.fn.expand("%:p")
-- 	vim.fn.setreg("+", path)
-- 	print("file:", path)
-- end, { desc = "Copy full file path" })



-- ============================================================================
-- AUTOCMDS
-- ============================================================================

local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

-- highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function() vim.highlight.on_yank() end,
})

-- return to last cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup,
  desc = "Restore last cursor position",
  callback = function()
    if vim.o.diff then -- except in diff mode
      return
    end

    local last_pos = vim.api.nvim_buf_get_mark(0, '"') -- {line, col}
    local last_line = vim.api.nvim_buf_line_count(0)

    local row = last_pos[1]
    if row < 1 or row > last_line then
      return
    end

    pcall(vim.api.nvim_win_set_cursor, 0, last_pos)
  end,
})

-- wrap, linebreak and spellcheck on markdown and text files
-- vim.api.nvim_create_autocmd("FileType", {
--   group = augroup,
--   pattern = { "markdown", "text", "gitcommit" },
--   callback = function()
--     vim.opt_local.wrap = true
--     vim.opt_local.linebreak = true
--     vim.opt_local.spell = true
--   end,
-- })

-- Makes terminal in insert mode on win enter
vim.api.nvim_create_autocmd("WinEnter", {
  callback = function()
    if vim.bo.buftype == "terminal" then vim.cmd("startinsert") end
  end,
})


-- ============================================================================
-- PLUGINS (vim.pack)
-- ============================================================================

local function gh(repo) return "https://github.com/" .. repo; end

-- TODO: fix statusline? (VISUAL MODE INDICATOR ONLY UPDATES WHEN A NEW MOVE IS DONE)

-- TODO: add:
--    - dap
--    - proper lsp
vim.pack.add({
  gh("folke/lazydev.nvim"),
  gh("lewis6991/gitsigns.nvim"),
  gh("echasnovski/mini.nvim"),
  gh("ibhagwan/fzf-lua"),
  gh("A7Lavinraj/fyler.nvim"),
  gh("nvim-tree/nvim-web-devicons"),
  {
    src = gh("nvim-treesitter/nvim-treesitter"),
    branch = "main",
    build = ":TSUpdate",
  },
  gh("L3MON4D3/LuaSnip"),
  -- Language Server Protocols
  gh("neovim/nvim-lspconfig"),
  gh("mason-org/mason.nvim"),
  -- gh("creativenull/efmls-configs-nvim"),

  gh("hrsh7th/nvim-cmp"),
  gh("hrsh7th/cmp-calc"),
  gh("hrsh7th/cmp-path"),
  gh("hrsh7th/cmp-cmdline"),
  gh("hrsh7th/cmp-buffer"),
  gh("hrsh7th/cmp-nvim-lsp"),
  gh("saadparwaiz1/cmp_luasnip"),

  gh("ziglang/zig.vim"),
  gh("folke/which-key.nvim"),

  gh("jiaoshijie/undotree"),
  gh("kevinhwang91/nvim-ufo"),
  gh("kevinhwang91/promise-async"),
  gh("rafamadriz/friendly-snippets"),

  gh("ej-shafran/compile-mode.nvim"),
  gh("nvim-lua/plenary.nvim"),
  { src = gh("m00qek/baleia.nvim"), tag = "v1.3.0" },

  gh("stevearc/aerial.nvim"),
  gh("norcalli/nvim-colorizer.lua"),
  gh("lewis6991/hover.nvim"),

  gh("MeanderingProgrammer/render-markdown.nvim"),

  gh("folke/todo-comments.nvim"),

  gh("marilari88/twoslash-queries.nvim"),

  gh("danymat/neogen"),
})


-- ============================================================================
-- PLUGIN CONFIGS
-- ============================================================================

local wk = require('which-key');

require("aerial").setup({
  on_attach = function(bufnr)
    vim.keymap.set("n", "<leader>a{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
    vim.keymap.set("n", "<leader>a}", "<cmd>AerialNext<CR>", { buffer = bufnr })
  end,
})
require('which-key').add({ { "<leader>a", desc = "Aerial" } })
vim.keymap.set("n", "<leader>aa", "<cmd>AerialToggle!<CR>")

require('colorizer').setup(nil, { css = true })
require('render-markdown').setup()
require('todo-comments').setup()

local neogen = require('neogen')
neogen.setup({})
vim.keymap.set("n", "<leader>o", neogen.generate, { noremap = true, silent = true, desc = "Neogen generate" })


require("undotree").setup()
vim.keymap.set('n', '<leader>u', require('undotree').toggle, { desc = 'Undotree Toggle' })

require('twoslash-queries').setup({
  multi_line = true,  -- to print types in multi line mode
  is_enabled = true, -- to keep disabled at startup and enable it on request with the TwoslashQueriesEnable
  highlight = "Type", -- to set up a highlight group for the virtual text
})
vim.lsp.config("ts_ls", { on_attach = function(client, bufnr)
  local tsq = require("twoslash-queries")
  tsq.attach(client, bufnr)
  wk.add({ { "<leader>l/", desc = "Twoslash Queries", noremap = true, buffer = bufnr } })
  vim.keymap.set('n', '<leader>l//', '<cmd>TwoslashQueriesInspect<cr>', { desc = 'Inspect', noremap = true, silent = true, buffer = bufnr })
  vim.keymap.set('n', '<leader>l/t', function()
    if tsq.config.is_enabled then tsq.disable()
    else tsq.enable()
    end
  end, { desc = 'Toggle', noremap = true, silent = true, buffer = bufnr })
end })

local hover = require("hover")
hover.config({
  init = function()
    require("hover.providers.lsp")
    require('hover.providers.dap')
    -- require('hover.providers.fold_preview')
    require('hover.providers.diagnostic')
    require('hover.providers.man')
    -- require('hover.providers.dictionary')
  end,
  preview_opts = { border = 'single' },
  preview_window = false,
  title = true,
  mouse_providers = { 'LSP' },
  mouse_delay = 1000
})
vim.keymap.set("n", "K", hover.open, { desc = "Hover Documentation" })
vim.keymap.set("n", "gK", hover.select, { desc = "Hover Documentation (select)" })
vim.keymap.set("n", "<C-p>", function() hover.switch("previous") end,
  { desc = "Hover Documentation (previous source)" })
vim.keymap.set("n", "<C-n>", function() hover.switch("next") end,
  { desc = "Hover Documentation (next source)" })

-- TODO: fix treesitter not installing or registering parsers
local setup_treesitter = function()
  vim.keymap.set("n", "<leader>i", vim.treesitter.inspect_tree, { desc = "Inspect TreeSitter tree" })
  vim.opt.runtimepath:append(vim.fn.stdpath("data") .. "/site")

  local treesitter = require("nvim-treesitter")
  treesitter.setup({})

  local ensure_installed = {
  	"vim", "vimdoc",
  	"lua", "luadoc",
     "asm", "nasm",
     'vhdl', 'systemverilog',
  	"c", "cpp", "zig",
  	"go", "rust",
     "llvm",
     "make",
  	"markdown", 'markdown_inline',
  	"html", "css",
  	"javascript", "json",
  	"typescript", "vue", "svelte",
  	"bash", "zsh", "awk",
     'matlab',
  	"python",
     "ini", "yaml", "xml", "csv", 'properties', 'proto', 'query', 'regex',
     "http", 'nginx',
     "git_config", "git_rebase", "gitattributes", "gitcommit", "gitignore",
     'pem',
     'tmux',
     'udev', 'devicetree'
  }

  local config = require("nvim-treesitter.config")

  local already_installed = config.get_installed()
  -- vim.print(already_installed)

  local parsers_to_install = {}

  for _, parser in ipairs(ensure_installed) do
  	if not vim.tbl_contains(already_installed, parser) then
  		table.insert(parsers_to_install, parser)
  	end
  end
  -- vim.print(parsers_to_install, #parsers_to_install)

  if #parsers_to_install > 0 then
  	treesitter.install(parsers_to_install, { force = true, summary = true }):wait(30000000000)
  end

  local group = vim.api.nvim_create_augroup("TreeSitterConfig", { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    callback = function(args)
      if vim.list_contains(treesitter.get_installed(), vim.treesitter.language.get_lang(args.match)) then
        vim.treesitter.start(args.buf)
      end
    end,
  })
end

setup_treesitter()

local fyler = require("fyler");
---@diagnostic disable: missing-fields
fyler.setup({
  integrations = { icon = "nvim_web_devicons", },
  views = { finder = {
    git_status = { enabled = true, symbols = { Untracked = "?", Added = "+", Modified = "*", Deleted = "x", Renamed = ">", Copied = "~", Conflict = "!", Ignored = "#", } },
    close_on_select = true,
    confirm_simple = false,
    default_explorer = true,
    delete_to_trash = true,
    columns = {
      git = {
        enabled = true,
        symbols = { Untracked = "?", Added = "+", Modified = "*", Deleted = "x", Renamed = ">", Copied = "~", Conflict = "!", Ignored = "#", },
      },
    },
    icon = {
      directory_collapsed = nil,
      directory_empty = nil,
      directory_expanded = nil,
    },
    indentscope = {
      enabled = true,
      group = "FylerIndentMarker",
      markers = "│",
    },
    mappings = {
      ["q"] = "CloseView",
      ["<CR>"] = "Select",
      ["<C-t>"] = "SelectTab",
      ["|"] = "SelectVSplit",
      ["-"] = "SelectSplit",
      ["^"] = "GotoParent",
      ["="] = "GotoCwd",
      ["."] = "GotoNode",
      ["#"] = "CollapseAll",
      ["<BS>"] = "CollapseNode",
    },
    mappings_opts = {
      nowait = false,
      noremap = true,
      silent = true,
    },
    follow_current_file = true,
    watcher = { enabled = false, },
    win = {
      border = vim.o.winborder == "" and "single" or vim.o.winborder,
      buf_opts = {
        filetype = "fyler",
        syntax = "fyler",
        buflisted = false,
        buftype = "acwrite",
        expandtab = true,
        shiftwidth = 2,
      },
      kind = "replace",
      kinds = {
        float = {
          height = "70%",
          width = "70%",
          top = "10%",
          left = "15%",
        },
        replace = {},
        split_above = { height = "70%", },
        split_above_all = {
          height = "70%",
          win_opts = {
            winfixheight = true,
          },
        },
        split_below = {
          height = "70%",
        },
        split_below_all = {
          height = "70%",
          win_opts = {
            winfixheight = true,
          },
        },
        split_left = {
          width = "30%",
        },
        split_left_most = {
          width = "30%",
          win_opts = { winfixwidth = true, },
        },
        split_right = {
          width = "30%",
        },
        split_right_most = {
          width = "30%",
          win_opts = {
            winfixwidth = true,
          },
        },
      },
      win_opts = {
        concealcursor = "nvic",
        conceallevel = 3,
        cursorline = false,
        number = false,
        relativenumber = false,
        winhighlight = "Normal:FylerNormal,NormalNC:FylerNormalNC",
        wrap = false,
        signcolumn = "yes",
      },
    }
  } }
  ---@diagnostic enable: missing-fields
})

local function run_cmd_capture(cmd)
  vim.v.errmsg = ""
  vim.cmd("redir => g:__cmd_output")
  vim.cmd("silent " .. cmd)
  vim.cmd("redir END")

  local out = vim.g.__cmd_output or ""
  vim.g.__cmd_output = nil

  return out, vim.v.errmsg
end

local function is_intro_buffer()
  local name = vim.api.nvim_buf_get_name(0)
  local buftype = vim.bo.buftype
  local line_count = vim.api.nvim_buf_line_count(0)
  local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]
  return name == "" and buftype == "" and line_count <= 1 and (first_line == "" or first_line == nil)
end

vim.keymap.set("n", "<leader>e", function()
  if is_intro_buffer() then
    fyler.toggle({ kind = "replace" });
  elseif vim.bo.filetype ~= "fyler" then
    fyler.toggle({ kind = "split_left_most" });
  elseif #vim.api.nvim_tabpage_list_wins(0) > 1 then
    fyler.toggle({ kind = "split_left_most" });
  else
    run_cmd_capture("intro");
  end
end, { desc = "Open Fyler explorer", silent = true, noremap = true })

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local args = vim.fn.argv()
    local is_dir = (#args == 1) and vim.fn.isdirectory(args[1]) == 1
    if is_dir then
      vim.api.nvim_set_current_dir(args[1])
      fyler.open({ kind = "replace" }) -- Open it with oil.nvim
      vim.bo.buflisted = false;
    end
  end,
})

vim.api.nvim_set_hl(0, "NvimTreeNormalNC", { bg = "none" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "NvimTreeSignColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = "none" })
vim.api.nvim_set_hl(0, "NvimTreeWinSeparator", { fg = "#2a2a2a", bg = "none" })
vim.api.nvim_set_hl(0, "NvimTreeEndOfBuffer", { bg = "none" })

local isWhitespace = function(s)
  return s:match("[^%s]") == nil
end
local hasPragma = function(s)
  return s:match("#pragma") ~= nil
end
local hasEndregion = function(s)
  return s:match("endregion") ~= nil
end
local trim = function(s)
  return s:gsub("^%s+", ""):gsub("%s+$", "")
end

require("ufo").setup({
  enable_get_fold_virt_text = true,
  provider_selector = function(bufnr, filetype, buftype)
    _, _, _ = bufnr, filetype, buftype; return { 'treesitter', 'indent' }
  end,                                                                                                                            --maybe not use this?
  fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate, ctx)
    local newVirtText = {}
    local suffix = (' \\\\--- %d ---// '):format(endLnum - lnum)
    local sufWidth = vim.fn.strdisplaywidth(suffix)
    local targetWidth = width - sufWidth
    local curWidth = 0

    for _, chunk in ipairs(virtText) do
      chunk[1] = chunk[1]:gsub("#pragma ", "")
      local chunkText = chunk[1]
      local chunkWidth = vim.fn.strdisplaywidth(chunkText)
      if targetWidth > curWidth + chunkWidth then
        table.insert(newVirtText, chunk)
      else
        chunkText = truncate(chunkText, targetWidth - curWidth)
        local hlGroup = chunk[2]
        table.insert(newVirtText, { chunkText, hlGroup })
        chunkWidth = vim.fn.strdisplaywidth(chunkText)
        -- str width returned from truncate() may less than 2nd argument, need padding
        if curWidth + chunkWidth < targetWidth then
          suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
        end
        break
      end
      curWidth = curWidth + chunkWidth
    end

    table.insert(newVirtText, { suffix, 'MoreMsg' }) --middle

    local begin = false
    for _, v in ipairs(ctx.get_fold_virt_text(endLnum)) do
      v[1] = trim(v[1])
      if begin or (not isWhitespace(v[1]) and not hasPragma(v[1]) and not hasEndregion(v[1])) then
        begin = true
        table.insert(newVirtText, v)
      end
    end

    return newVirtText
  end,
  preview = { win_config = { border = "single" } }
});


local fzf_lua = require("fzf-lua")
fzf_lua.setup({})
vim.keymap.set("n", "<leader>fo", fzf_lua.oldfiles, { desc = "FZF Files" })
vim.keymap.set("n", "<leader>ff", fzf_lua.files, { desc = "FZF Files" })
vim.keymap.set("n", "<leader>fl", fzf_lua.live_grep, { desc = "FZF Diagnostics Workspace" })
vim.keymap.set("n", "<leader>fg", fzf_lua.live_grep, { desc = "FZF Live Grep" })
vim.keymap.set("n", "<leader>fb", fzf_lua.buffers, { desc = "FZF Buffers" })
vim.keymap.set("n", "<leader>fh", fzf_lua.help_tags, { desc = "FZF Help Tags" })
vim.keymap.set("n", "<leader>fx", fzf_lua.diagnostics_document, { desc = "FZF Diagnostics Document" })
vim.keymap.set("n", "<leader>fX", fzf_lua.diagnostics_workspace, { desc = "FZF Diagnostics Workspace" })

require("mini.ai").setup()
require("mini.comment").setup()
require("mini.move").setup()
-- require("mini.cursorword").setup()
-- require("mini.indentscope").setup()
require("mini.pairs").setup()
require("mini.trailspace").setup()
require("mini.bufremove").setup()
require("mini.notify").setup()
require("mini.icons").setup()
require("mini.surround").setup()
require("mini.align").setup({ mappings = { start = '<leader>+', start_with_preview = '<leader>=' } })
require('mini.tabline').setup({ show_icons = false, format = function(buf_id, label)
  local default_label = MiniTabline.default_format(buf_id, label)
  if vim.bo[buf_id].modified then return '[' .. default_label .. ']' end
  return default_label
end })

local function reset_tabline_modified_styles()
  vim.api.nvim_set_hl(0, 'MiniTablineModifiedCurrent', { link = 'MiniTablineCurrent' })
  vim.api.nvim_set_hl(0, 'MiniTablineModifiedVisible', { link = 'MiniTablineVisible' })
  vim.api.nvim_set_hl(0, 'MiniTablineModifiedHidden',  { link = 'MiniTablineHidden'  })
end
reset_tabline_modified_styles()
vim.api.nvim_create_autocmd('ColorScheme', { callback = reset_tabline_modified_styles })

require("mini.snippets").setup()
-- require("mini.completion").setup()

vim.keymap.set("n", "<leader>bd", "<cmd>bd<cr>", { desc = "Buf delete", noremap = true })

local gs = require("gitsigns")
gs.setup({
  signs = {
    add = { text = "\u{2590}" },        -- ▏
    change = { text = "\u{2590}" },     -- ▐
    delete = { text = "\u{2590}" },     -- ◦
    topdelete = { text = "\u{25e6}" },  -- ◦
    changedelete = { text = "\u{25cf}" }, -- ●
    untracked = { text = "\u{25cb}" },  -- ○
  },
  signcolumn = true,
  current_line_blame = false,
})
vim.keymap.set("n", "]h", function() gs.nav_hunk('next') end, { desc = "Next git hunk" })
vim.keymap.set("n", "[h", function() gs.nav_hunk('prev') end, { desc = "Previous git hunk" })
vim.keymap.set("n", "<leader><leader>hs", function() gs.stage_hunk() end, { desc = "Stage hunk" })
vim.keymap.set("n", "<leader><leader>hr", function() gs.reset_hunk() end, { desc = "Reset hunk" })
vim.keymap.set("n", "<leader><leader>hp", function() gs.preview_hunk() end, { desc = "Preview hunk" })
vim.keymap.set("n", "<leader><leader>hb", function() gs.blame_line({ full = true }) end,
  { desc = "Blame line" })
vim.keymap.set("n", "<leader><leader>hB", function() gs.toggle_current_line_blame() end,
  { desc = "Toggle inline blame" })
vim.keymap.set("n", "<leader><leader>hd", function() gs.diffthis() end, { desc = "Diff this" })

--- get_compile_buffer
---@return integer
local function get_compilation_buffer()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    -- Check if the buffer is valid and loaded
    if vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted then
      local filetype = vim.bo[bufnr].filetype
      if filetype == 'compilation' then
        return bufnr -- Found a buffer with filetype 'compilation'
      end
    end
  end
  return -1 -- No buffer with filetype 'compilation' found
end

---
---@param bufnr_to_find integer
---@return boolean
local function jump_to_buffer_in_window(bufnr_to_find)
  local all_tabpages = vim.api.nvim_list_tabpages()

  for _, tabpage in ipairs(all_tabpages) do
    local win_list = vim.api.nvim_tabpage_list_wins(tabpage)
    for _, win_id in ipairs(win_list) do
      local current_buf_in_win = vim.api.nvim_win_get_buf(win_id)
      if current_buf_in_win == bufnr_to_find then
        vim.api.nvim_set_current_win(win_id)
        return true -- Buffer found and jumped to
      end
    end
  end
  return false -- Buffer not found in any window
end

--- Exec function in other buffer
---@param bufnr integer
---@param fn function
local function do_in_other_buffer(bufnr, fn, report)
  local cb = vim.api.nvim_get_current_buf();
  if bufnr >= 0 then
    jump_to_buffer_in_window(bufnr);
    fn();
    jump_to_buffer_in_window(cb);
  elseif report then
    error("Buffer " .. bufnr .. " not found");
  end
end

-- compile-mode

---@type CompileModeOpts
vim.g.compile_mode = {
  input_word_completion = true,
  bang_expansion = true,
  use_diagnostics = true,
  -- to add ANSI escape code support, add:
  baleia_setup = true,
}

local cm = require('compile-mode')

require('which-key').add({ { '<leader>c', desc = 'Compile', noremap = true } })
vim.keymap.set('n', '<leader>cc', function()
  local bufnr = get_compilation_buffer();
  if bufnr >= 0 then
    cm.recompile();
  else
    cm.compile();
    cm.send_to_qflist();
  end
end, { desc = 'Compile mode' })

vim.keymap.set('n', '<leader>cC', function()
  cm.compile();
  cm.send_to_qflist();
end, { desc = 'Compile mode' })

-- vim.g.non_free_standing_filetypes = { "compilation", "fyler" }
-- vim.api.nvim_create_autocmd("WinClosed", {
--   callback = function() vim.schedule(function()
--     if table.contains(vim.g.non_free_standing_filetypes, vim.bo.filetype) then return end
--     local count = 0
--     for _, win in ipairs(vim.api.nvim_list_wins()) do
--       local cfg = vim.api.nvim_win_get_config(win)
--       if cfg.relative == "" and
--         not table.contains(vim.g.non_free_standing_filetypes, vim.bo[vim.api.nvim_win_get_buf(win)].filetype)
--       then count = count + 1 end
--     end
--     if count ~= 0 then return end
--     for _, buf in ipairs(vim.api.nvim_list_bufs()) do
--       if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].modified then
--         vim.api.nvim_set_current_buf(buf)
--         return
--       end
--     end
--     vim.cmd(":q!")
--   end) end
-- });


-- Closes compilation window if the last one open
vim.api.nvim_create_autocmd("WinClosed", {
  callback = function() vim.schedule(function()
    if vim.bo.filetype ~= "compilation" then return end
    local count = 0
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local cfg = vim.api.nvim_win_get_config(win)
      if cfg.relative == "" then count = count + 1 end
    end
    if count ~= 1 then return end
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].modified then
        vim.api.nvim_set_current_buf(buf)
        return
      end
    end
    vim.cmd(":q!")
  end) end
});


vim.keymap.set('n', ']e', function()
  local bufnr = get_compilation_buffer();
  do_in_other_buffer(bufnr, function()
    vim.o.cursorline = true;
    -- TODO: find a way to keep the compilation window oppened
    cm.move_to_next_error();
  end)
end, { desc = 'Next compilation error' })

vim.keymap.set('n', '[e', function()
  local bufnr = get_compilation_buffer();
  do_in_other_buffer(bufnr, function()
    vim.o.cursorline = true;
    -- TODO: find a way to keep the compilation window oppened
    cm.move_to_prev_error();
    -- cm.goto_error();
  end)
end, { desc = 'Previous compilation error' })



require('which-key').add({ { '<leader>cn', desc = 'Next', noremap = true } })
vim.keymap.set('n', '<leader>cnf', function()
  vim.cmd('CompileNextFile')
end, { desc = 'Next file' })
vim.keymap.set('n', '<leader>cne', function()
  vim.cmd('CompileNextError')
end, { desc = 'Next error' })

require('which-key').add({ { '<leader>cp', desc = 'Previous', noremap = true } })
vim.keymap.set('n', '<leader>cpf', function()
  vim.cmd('CompilePrevFile')
end, { desc = 'Previous file' })
vim.keymap.set('n', '<leader>cpe', function()
  vim.cmd('CompilePrevError')
end, { desc = 'Previous error' })


vim.keymap.set('n', '<leader>cd', function()
  vim.cmd('CompileDebugError')
end, { desc = 'Debug error' })
vim.keymap.set('n', '<leader>cg', function()
  vim.cmd('CompileGotoError')
end, { desc = 'Goto error' })
vim.keymap.set('n', '<leader>ci', function()
  vim.cmd('CompileInterrupt')
end, { desc = 'Interrupt' })

vim.g.zig_fmt_autosave = 0

require('which-key').add({ { '<leader>b', desc = 'Buffer', noremap = true } })
require('which-key').add({ { '<leader>t', desc = 'Tab', noremap = true } })

require("mason").setup()


-- ============================================================================
-- LSP, Linting, Formatting & Completion
-- ============================================================================

local luasnip = require('luasnip')
luasnip.config.setup({})

local diagnostic_signs = {
  Error = " ",
  Warn = " ",
  Hint = "",
  Info = "",
}

vim.diagnostic.config({
  virtual_text = { prefix = "●", spacing = 4 },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = diagnostic_signs.Error,
      [vim.diagnostic.severity.WARN] = diagnostic_signs.Warn,
      [vim.diagnostic.severity.HINT] = diagnostic_signs.Hint,
      [vim.diagnostic.severity.INFO] = diagnostic_signs.Info,
    },
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    -- source = "always",
    header = "",
    prefix = "",
    focusable = false,
    style = "minimal",
  },
})


require("lazydev").setup({
  library = {
    { path = "${3rd}/luv/library",        words = { "vim%.uv" } },
    { path = "wezterm-types",             mods = { "wezterm" } },
    { path = "xmake-luals-addon/library", files = { "xmake.lua" } },
  },
  enabled = function(root_dir)
    local _ = root_dir;
    return vim.g.lazydev_enabled == nil and true or vim.g.lazydev_enabled
  end,
})

-- do
-- 	local orig = vim.lsp.util.open_floating_preview
-- 	function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
-- 		opts = opts or {}
-- 		opts.border = opts.border or "rounded"
-- 		return orig(contents, syntax, opts, ...)
-- 	end
-- end

local function lsp_on_attach(ev)
  local client = vim.lsp.get_client_by_id(ev.data.client_id)
  if not client then return; end

  local bufnr = ev.buf
  local opts = { noremap = true, silent = true, buffer = bufnr }
  local buf = vim.lsp.buf

  vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, { desc = 'Type Definition' })

  wk.add({ { '<leader>l', desc = 'LSP' } });
  vim.keymap.set('n', '<leader>lf', buf.format, { desc = 'Format' })
  vim.keymap.set('n', '<leader>lr', buf.rename, { desc = 'Rename' })
  vim.keymap.set('n', '<leader>la', buf.code_action, { desc = 'Code Actions' })

  wk.add({ { '<leader>ls', desc = 'Split horizontaly and...' } });
  wk.add({ { '<leader>lv', desc = 'Split verticaly and...' } });

  vim.keymap.set('n', '<leader>lsd', function()
    vim.cmd("split")
    buf.definition()
  end, { desc = 'Goto Definition' })
  vim.keymap.set('n', '<leader>lvd', function()
    vim.cmd("vsplit")
    buf.definition()
  end, { desc = 'Goto Definition' })

  vim.keymap.set('n', '<leader>lR', ':LspRestart<cr>', { desc = 'Restart LSP' })

  wk.add({ { '<leader>w', desc = 'Workspace' } });
  vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, { desc = 'Workspace Add Folder' })
  vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, { desc = 'Workspace Remove Folder' })
  vim.keymap.set('n', '<leader>ww', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
    { desc = 'Workspace List Folders' })

  wk.add({ { '<leader>g', desc = 'Goto' } });

  vim.keymap.set('n', '<leader>gd', buf.definition, { desc = 'Goto Definition' })
  vim.keymap.set('n', '<leader>gD', vim.lsp.buf.declaration, { desc = 'Goto Declaration' })
  vim.keymap.set('n', '<leader>gI', buf.implementation, { desc = 'Goto Implementation' })
  vim.keymap.set('n', 'gd', buf.definition, { desc = 'Goto Definition' })
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = 'Goto Declaration' })
  vim.keymap.set('n', 'gI', buf.implementation, { desc = 'Goto Implementation' })

  -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Hover Documentation' })
  vim.keymap.set('i', '<C-\\>', vim.lsp.buf.signature_help, { desc = 'Signature Documentation' })

  -- if client.server_capabilities["documentSymbolProvider"] then
  --   require("nvim-navic").attach(client, bufnr)
  -- end

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })


  vim.keymap.set("n", "<leader>fd", function()
    require("fzf-lua").lsp_definitions({ jump_to_single_result = true })
  end, opts)
  vim.keymap.set("n", "<leader>fr", function()
    require("fzf-lua").lsp_references()
  end, opts)
  vim.keymap.set("n", "<leader>ft", function()
    require("fzf-lua").lsp_typedefs()
  end, opts)
  vim.keymap.set("n", "<leader>fs", function()
    require("fzf-lua").lsp_document_symbols()
  end, opts)
  vim.keymap.set("n", "<leader>fw", function()
    require("fzf-lua").lsp_workspace_symbols()
  end, opts)
  vim.keymap.set("n", "<leader>fi", function()
    require("fzf-lua").lsp_implementations()
  end, opts)
end

vim.api.nvim_create_autocmd("LspAttach", { group = augroup, callback = lsp_on_attach })

-- vim.keymap.set("n", "<leader>dq", function()
-- 	vim.diagnostic.setloclist({ open = true })
-- end, { desc = "Open diagnostic list" })
-- vim.keymap.set("n", "<leader>dl", vim.diagnostic.open_float, { desc = "Show line diagnostics" })

local servers = {
  clangd = {
    -- capabilities = capabilities;
    -- cmd = { "/home/vinicius/.espressif/tools/esp-clang/esp-18.1.2_20240912/esp-clang/bin/clangd", "--background-index", "--query-driver=**", },
    -- root_dir = function()
    --   -- leave empty to stop nvim from cd'ing into ~/ due to global .clangd file
    -- end
    cmd = { "clangd", "--compile-commands-dir=." },
    -- root_dir = require('lspconfig.util').root_pattern('compile_commands.json', '.git'),
  },
  lua_ls = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      workspace = { checkThirdParty = false },
      telemetry = { enable = false }
    }
  },
  ansiblels = {},
  -- ["ansible-lint"] = {},
  arduino_language_server = {},
  -- asm_lsp = {},
  asmfmt = {},
  bashls = {},
  beautysh = {},
  ["buf-language-server"] = {},
  checkmake = {},
  ["clang-format"] = {},
  cmake = {},
  cmakelang = {},
  cmakelint = {},
  codelldb = {},
  cpplint = {},
  cpptools = {},
  cssls = {},
  css_variables = {},
  cssmodules_ls = {},
  ["dart-debug-adapter"] = {},
  dcm = {},
  docker_compose_language_service = {},
  dockerls = {},
  eslint = {},
  eslint_d = {},
  ["firefox-debug-adapter"] = {},
  gitleaks = {},
  gitlint = {},
  gitui = {},
  glow = {},
  glsl_analyzer = {},
  glslls = {},
  html = {},
  htmlbeautifier = {},
  htmlhint = {},
  ["js-debug-adapter"] = {},
  jsonls = {},
  jsonnetfmt = {},
  latexindent = {},
  ltex = {},
  luacheck = {},
  luaformatter = {},
  markdown_oxide = {},
  marksman = {},
  markuplint = {},
  -- ["node-debug2-adapter"] = {},
  prettier = {},
  prettierd = {},
  pyright = {},
  remark_ls = {},
  rust_analyzer = {},
  shellcheck = {},
  -- shellharden = {},
  shfmt = {},
  sqlfmt = {},
  sqls = {},
  svelte = {},
  systemdlint = {},
  taplo = {},
  ["tree-sitter-cli"] = {},
  ["ts-standard"] = {},
  ts_ls = {},
  xmlformatter = {},
  yamlls = {},
  yamlfix = {},
  yamlfmt = {},
  yamllint = {},
  zls = {},
}

for sname, sconfig in pairs(servers) do
  vim.lsp.config(sname, sconfig)
end

-- do
--   local luacheck = require("efmls-configs.linters.luacheck")
--   local stylua = require("efmls-configs.formatters.stylua")
--
--   local flake8 = require("efmls-configs.linters.flake8")
--   local black = require("efmls-configs.formatters.black")
--
--   local prettier_d = require("efmls-configs.formatters.prettier_d")
--   local eslint_d = require("efmls-configs.linters.eslint_d")
--
--   local fixjson = require("efmls-configs.formatters.fixjson")
--
--   local shellcheck = require("efmls-configs.linters.shellcheck")
--   local shfmt = require("efmls-configs.formatters.shfmt")
--
--   local cpplint = require("efmls-configs.linters.cpplint")
--   local clangfmt = require("efmls-configs.formatters.clang_format")
--
--   local go_revive = require("efmls-configs.linters.go_revive")
--   local gofumpt = require("efmls-configs.formatters.gofumpt")
--
--   vim.lsp.config("efm", {
--     filetypes = {
--       "c",
--       "cpp",
--       "css",
--       "go",
--       "html",
--       "javascript",
--       "javascriptreact",
--       "json",
--       "jsonc",
--       "lua",
--       "markdown",
--       "python",
--       "sh",
--       "typescript",
--       "typescriptreact",
--       "vue",
--       "svelte",
--     },
--     init_options = { documentFormatting = true },
--     settings = {
--       languages = {
--         c = { clangfmt, cpplint },
--         go = { gofumpt, go_revive },
--         cpp = { clangfmt, cpplint },
--         css = { prettier_d },
--         html = { prettier_d },
--         javascript = { eslint_d, prettier_d },
--         javascriptreact = { eslint_d, prettier_d },
--         json = { eslint_d, fixjson },
--         jsonc = { eslint_d, fixjson },
--         lua = { luacheck, stylua },
--         markdown = { prettier_d },
--         python = { flake8, black },
--         sh = { shellcheck, shfmt },
--         typescript = { eslint_d, prettier_d },
--         typescriptreact = { eslint_d, prettier_d },
--         vue = { eslint_d, prettier_d },
--         svelte = { eslint_d, prettier_d },
--       },
--     },
--   })
-- end

local function keys(tbl)
  local ks = {}
  for k in pairs(tbl) do table.insert(ks, k) end
  return ks;
end

vim.lsp.enable(keys(servers))



-- ============================================================================
-- FLOATING TERMINAL
-- ============================================================================
vim.api.nvim_create_autocmd("TermClose", {
  group = augroup,
  callback = function()
    if vim.v.event.status == 0 then
      vim.api.nvim_buf_delete(0, {})
    end
  end,
})

vim.api.nvim_create_autocmd("TermOpen", {
  group = augroup,
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
  end,
})

vim.ft = {}
vim.ft.state = { buf = nil, win = nil, is_open = false }

local function FloatingTerminal()
  if vim.ft.state.is_open and vim.ft.state.win and vim.api.nvim_win_is_valid(vim.ft.state.win) then
    vim.api.nvim_win_close(vim.ft.state.win, false)
    vim.ft.state.is_open = false
    -- vim.cmd.redrawstatus()
    return
  end

  if not vim.ft.state.buf or not vim.api.nvim_buf_is_valid(vim.ft.state.buf) then
    vim.ft.state.buf = vim.api.nvim_create_buf(false, true)
    vim.bo[vim.ft.state.buf].bufhidden = "hide"
  end

  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  vim.ft.state.win = vim.api.nvim_open_win(vim.ft.state.buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
  })

  vim.wo[vim.ft.state.win].winblend = 0
  vim.wo[vim.ft.state.win].winhighlight = "Normal:FloatingTermNormal,FloatBorder:FloatingTermBorder"
  vim.api.nvim_set_hl(0, "FloatingTermNormal", { bg = "none" })
  vim.api.nvim_set_hl(0, "FloatingTermBorder", { bg = "none" })

  local has_terminal = false
  local lines = vim.api.nvim_buf_get_lines(vim.ft.state.buf, 0, -1, false)
  for _, line in ipairs(lines) do
    if line ~= "" then
      has_terminal = true
      break
    end
  end
  if not has_terminal then vim.cmd("terminal "..(os.getenv("SHELL") or "bash")); end

  vim.ft.state.is_open = true
  vim.cmd("startinsert")

  -- TODO: fix statusline broken after entering ou command `exit` on float terminal

  -- vim.api.nvim_create_autocmd({ "BufDelete" }, {
  --   buffer = vim.ft.state.buf,
  --   callback = vim.cmd.redrawstatus,
  --   once = true,
  -- })

  vim.api.nvim_create_autocmd("BufLeave", {
    buffer = vim.ft.state.buf,
    callback = function()
      if vim.ft.state.is_open and vim.ft.state.win and vim.api.nvim_win_is_valid(vim.ft.state.win) then
        vim.api.nvim_win_close(vim.ft.state.win, false)
        vim.ft.state.is_open = false
      end
      vim.cmd.redrawstatus()
    end,
    once = true,
  })
end

-- TODO: fix terminal_state.is_open update on buff exit
-- vim.keymap.set("n", "<leader>t", FloatingTerminal, { noremap = true, silent = true, desc = "Toggle floating terminal" })
vim.keymap.set({ "n", "t" }, "<M-t>", function()
  if vim.ft.state.is_open and vim.ft.state.win and vim.api.nvim_win_is_valid(vim.ft.state.win) then
    vim.api.nvim_win_hide(vim.ft.state.win)
    vim.ft.state.is_open = false
  else
    FloatingTerminal()
  end
end, { noremap = true, silent = true, desc = "Close floating terminal" })


-- ============================================================================
-- STATUSLINE
-- ============================================================================


vim.o.cmdheight = 1
vim.o.showcmd = false
-- vim.o.showcmdloc = "statusline"
vim.o.laststatus = 3
vim.o.ruler = false
local statusline = require("statusline")
statusline.setup()
statusline.enable()



local cmbed = require("combed")
-- cmbed.setup()
vim.keymap.set({ 'n' }, '<M-X>', cmbed.executeCommandInBuffer(false), { desc = 'Execute command in place' })
vim.keymap.set({ 'n' }, '<M-x>', cmbed.executeCommandInBuffer(true), { desc = 'Execute command in place and replace' })

vim.keymap.set('n', '<leader>A', vim.utils.print_current_char_code, { desc = 'Code of char under cursor', noremap = true, silent = true })



-- vim.api.nvim_create_autocmd("WinEnter", { callback = function() vim.print(vim.bo.filetype) end })
















-- function vim.fn.inspect_()
--   vim.treesitter.query.set("lua", "injections", [[
--     ((comment_content) @_command (#match? @_command "^[ \n\r-]*:[^!]")) @vim
--     ((comment_content) @_bash_command (#match? @_bash_command "^[ \n\r-]*(:?)!")) @bash
--   ]])
--
--   vim.treesitter.query.set("lua", "highlight", [[
--     ((comment_content) @_command (#match? @_command "^[ \n\r-]*:[^!]")) @vim
--     ((comment_content) @_bash_command (#match? @_bash_command "^[ \n\r-]*(:?)!")) @bash
--   ]])
-- end
--
-- -- require('cmbed').enable()
--
-- function vim.fn.inspect()
--   vim.treesitter.query.set("lua", "injections", [[
--     ((comment_content) @_command (#match? @_command "^[ \n\r-]*:[^!]")) @vim
--     ((comment_content) @_bash_command (#match? @_bash_command "^[ \n\r-]*(:?)!")) @bash
--   ]])
--   return true
-- end






-- local function preprocessCFile()
--   local current_file = vim.fn.expand('%:p')
--
--   if not current_file:match('%.c$') and not current_file:match('%.h$') then
--     print("Not a C or header file")
--     return
--   end
--
--   vim.notify("Preprocessing...", vim.log.levels.INFO, { title = "PreprocessCFile" })
--   local output = vim.fn.system("make --quiet preprocess filename=" ..
--     current_file .. ' 2>&1 | grep --invert-match "^#" | clang-format | sed \'/./,/^$/!d; /^$/N;/\\n$/D\'')
--
--   vim.cmd('new')        -- Open a new buffer
--   vim.bo.filetype = 'c' -- Set filetype to C
--   vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(output, "\n"))
--   vim.cmd('setlocal buftype=nofile') -- Set buffer as not a file
-- end
--
-- vim.api.nvim_create_user_command('PreprocessC', preprocessCFile, {})
-- vim.keymap.set('n', '<leader>lp', preprocessCFile, { desc = 'Preprocess C File' })
