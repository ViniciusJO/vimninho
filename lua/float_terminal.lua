local ftgrp = vim.api.nvim_create_augroup("FloatTerminal", { clear = true })

-- vim.api.nvim_create_autocmd("TermClose", {
--   group = ftgrp,
--   callback = function()
--     if vim.v.event.status == 0 then
--       vim.api.nvim_buf_delete(0, {})
--     end
--   end,
-- })

vim.api.nvim_create_autocmd("TermOpen", {
  group = ftgrp,
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
  end,
})

vim.ft = {}
vim.ft.state = { buf = nil, win = nil, is_open = false }

local function floating_terminal()
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
    floating_terminal()
  end
end, { noremap = true, silent = true, desc = "Toggle floating terminal" })
