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

-- Makes terminal in insert mode on win enter
vim.api.nvim_create_autocmd("WinEnter", {
  callback = function()
    if vim.bo.buftype == "terminal" then vim.cmd("startinsert") end
  end,
})

vim.g.non_free_standing_filetypes = { "compilation", "fyler" }
vim.api.nvim_create_autocmd("WinClosed", {
  callback = function()
    vim.schedule(function()
      local ft = vim.bo.filetype
      local function not_nfsf(filetype)
        return not vim.tbl_contains(vim.g.non_free_standing_filetypes, filetype)
      end
      if not_nfsf(ft) then return end

      local count = 0
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local cfg = vim.api.nvim_win_get_config(win)
        local win_buf = vim.api.nvim_win_get_buf(win)
        if cfg.relative == "" and not_nfsf(vim.bo[win_buf].filetype) then count = count + 1 end
      end


      if count ~= 0 then return end
      if ft == "fyler" then
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local cfg = vim.api.nvim_win_get_config(win)
          local win_buf = vim.api.nvim_win_get_buf(win)
          if cfg.relative == "" and vim.bo[win_buf].filetype ~= "fyler" then count = count + 1 end
        end
        if count == 0 then return end
      end

      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].modified then
          vim.api.nvim_set_current_buf(buf)
          return
        end
      end
      vim.cmd(":qa!")
    end)
  end
});


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
