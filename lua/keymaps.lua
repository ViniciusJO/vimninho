vim.g.mapleader = " "      -- space for leader
vim.g.maplocalleader = " " -- space for localleader

vim.g.runtimepath = vim.api.nvim_list_runtime_paths()[1]

---Returns default keymap options (desc+noremap+silent)
---@param description string
---@return { desc: string, noremap: true, silent: true }
local function makeopt(description)
  return { desc = description, noremap = true, silent = true }
end

-- Source configs
vim.keymap.set('n', '<leader>r', function() vim.cmd.source(vim.g.runtimepath .. '/init.lua') end,
  { desc = 'Source configs', silent = false, noremap = true })

vim.keymap.set({ 'n' }, '<leader>Ll', ':source %<CR>', makeopt("Source current file"))
vim.keymap.set({ 'n' }, '<leader>LL', ':source '..vim.g.runtimepath..'/init.lua<CR>', makeopt("Source global config"))

-- jj go to normal mode
vim.keymap.set({ 'i' }, 'jj', '<esc>')
vim.keymap.set({ 't', 'c' }, 'jj', '<C-\\><C-n>')

-- Keymaps for save and quit
vim.keymap.set('n', '<C-s>', '<cmd>w<cr>', makeopt("Save buffer to file"))
vim.keymap.set('n', '<C-q>', '<cmd>q<cr>', makeopt("Quit window"))
vim.keymap.set('n', '<C-Q>', '<cmd>q!<cr>', makeopt("Quit window"))

-- Copy to systems clipboard
vim.keymap.set('n', 'Y', '"+y', makeopt("Yank to systems clipboard"));
vim.keymap.set('v', '<C-c>', '"+y', makeopt("Yank to systems clipboard"));

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
end, makeopt("Toggle arrow keys"))

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

vim.keymap.set("v", "<", "<gv", makeopt("Indent left and reselect"))
vim.keymap.set("v", ">", ">gv", makeopt("Indent right and reselect"))

vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", makeopt("Move line down"))
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", makeopt("Move line up"))
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", makeopt("Move selection down"))
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", makeopt("Move selection up"))

vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", makeopt("Increase window height"))
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", makeopt("Decrease window height"))
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", makeopt("Decrease window width"))
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", makeopt("Increase window width"))

vim.keymap.set('n', '<leader>h', '<cmd>set hlsearch!<CR>',
  { noremap = true, silent = true, desc = 'Toggle search highlight' })

vim.keymap.set("n", "n", "nzzzv", makeopt("Next search result (centered)"))
vim.keymap.set("n", "N", "Nzzzv", makeopt("Previous search result (centered)"))
vim.keymap.set("n", "<C-d>", "<C-d>zz", makeopt("Half page down (centered)"))
vim.keymap.set("n", "<C-u>", "<C-u>zz", makeopt("Half page up (centered)"))

vim.keymap.set("x", "<leader>p", '"_dP', makeopt("Paste without yanking"))
-- vim.keymap.set({ "n", "v" }, "<leader>x", '"_d', makeopt("Delete without yanking"))


vim.keymap.set("n", "<C-J>", "mzJ`z", makeopt("Join lines and keep cursor position"))

-- Toggle options
vim.keymap.set('n', '<M-z>', function() if (vim.o.wrap) then vim.o.wrap = false else vim.o.wrap = true end end,
  { desc = 'Toggle wrap', expr = true })
vim.keymap.set('n', '<M-r>',
  function() if (vim.o.relativenumber) then vim.o.relativenumber = false else vim.o.relativenumber = true end end,
  { desc = 'Toggle relative collumn number', expr = true })

-- Tabs
vim.keymap.set('n', '[t', '<CMD>tabnext<CR>', makeopt("Go to previous tab"))
vim.keymap.set('n', '[T', '<CMD>tablast<CR>', makeopt("Go to last tab"))
vim.keymap.set('n', ']t', '<CMD>tabprev<CR>', makeopt("Go to previous tab"))
vim.keymap.set('n', ']T', '<CMD>tabfirst<CR>', makeopt("Go to first tab"))
vim.keymap.set('n', '<leader>tn', '<CMD>tabnew<CR>', makeopt("Tab new"))
vim.keymap.set('n', '<leader>td', '<CMD>tabclose<CR>', makeopt("Tab close"))

-- Buffers
vim.keymap.set('n', '<leader>bd', '<CMD>bd<CR>', makeopt("Close Current Buffer"))
vim.keymap.set('n', '<leader>bn', '<CMD>enew<CR>', makeopt("Open Blank Buffer"))

-- Diagnostic
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, makeopt("Go to previous diagnostic message"))
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, makeopt("Go to next diagnostic message"))
vim.keymap.set('n', '<leader>dd', vim.diagnostic.open_float, makeopt("Open floating diagnostic message"))
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, makeopt("Open diagnostics list"))

vim.keymap.set("n", "<leader>le", function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, makeopt("Toggle diagnostics"))

-- Macros
vim.keymap.set('n', 'Q', '@q', makeopt("Plays macro at q"))
vim.keymap.set('x', 'Q', ':norm @q<CR>', makeopt("Plays macro at q on each lines selected"))

-- Terminal
vim.keymap.set('n', '<leader>x', '<cmd>split | term<CR>i',
  { noremap = true, silent = true, desc = 'Toggle split terminal' })
vim.keymap.set('n', '<leader>X', '<cmd>vsplit | term<CR>i',
  { noremap = true, silent = true, desc = 'Toggle split terminal [vertcal]' })
vim.keymap.set('t', '<esc><esc>', '<C-\\><C-n>', makeopt("Unfocus terminal"))
vim.keymap.set('t', '<C-w>', '<C-\\><C-n><C-w>', makeopt("Navigate"))

-- Visual Maps
vim.keymap.set("v", "<leader>r", "\"hy:%s/<C-r>h//g<left><left>", makeopt("Replace all instances of highlighted words"))
vim.keymap.set("v", "<C-s>", "<cmd>sort<CR>", makeopt("Sort highlighted text"))

-- Quickfix
vim.keymap.set({ 'n', 'v', 't' }, "<leader>q", function()
  for _, win in ipairs(vim.fn.getwininfo()) do
    if win.quickfix == 1 then
      vim.cmd("cclose")
      return
    end
  end
  vim.cmd("cw")
end, makeopt("Toggle quickfix list"))


-- vim.keymap.set("n", "<leader>bn", ":bnext<CR>", makeopt("Next buffer"))
-- vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", makeopt("Previous buffer"))

vim.keymap.set("n", "<leader>pa", function() -- show file path
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
	print("file:", path)
end, makeopt("Copy full file path"))
