vim.g.mapleader = " "      -- space for leader
vim.g.maplocalleader = " " -- space for localleader

vim.g.runtimepath = vim.api.nvim_list_runtime_paths()[1]

-- Source configs
vim.keymap.set('n', '<leader>r', function() vim.cmd.source(vim.g.runtimepath .. '/init.lua') end,
  { desc = 'Source configs', silent = false, noremap = true })

vim.keymap.set({ 'n' }, '<leader>Ll', ':source %<CR>', { desc = 'Source current file' })
vim.keymap.set({ 'n' }, '<leader>LL', ':source '..vim.g.runtimepath..'/init.lua<CR>', { desc = 'Source global config' })

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

vim.keymap.set("n", "<leader>pa", function() -- show file path
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
	print("file:", path)
end, { desc = "Copy full file path" })
