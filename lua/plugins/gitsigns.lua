---@type PackitElement
return {
  src = vim.pack.gh("lewis6991/gitsigns.nvim"),
  config = function()
    local gs = require("gitsigns")
    gs.setup({
      signs = {
        add = { text = "\u{2590}" },      -- ▏
        change = { text = "\u{2590}" },   -- ▐
        delete = { text = "\u{2590}" },   -- ◦
        topdelete = { text = "\u{25e6}" }, -- ◦
        changedelete = { text = "\u{25cf}" }, -- ●
        untracked = { text = "\u{25cb}" }, -- ○
      },
      signcolumn = true,
      current_line_blame = false,
    })
    vim.keymap.set("n", "]h", function() gs.nav_hunk('next') end, { desc = "Next git hunk" })
    vim.keymap.set("n", "[h", function() gs.nav_hunk('prev') end, { desc = "Previous git hunk" })
    vim.keymap.set("n", "<leader>Hs", function() gs.stage_hunk() end, { desc = "Stage hunk" })
    vim.keymap.set("n", "<leader>Hr", function() gs.reset_hunk() end, { desc = "Reset hunk" })
    vim.keymap.set("n", "<leader>Hp", function() gs.preview_hunk() end, { desc = "Preview hunk" })
    vim.keymap.set("n", "<leader>Hb", function() gs.blame_line({ full = true }) end,
      { desc = "Blame line" })
    vim.keymap.set("n", "<leader>HB", function() gs.toggle_current_line_blame() end,
      { desc = "Toggle inline blame" })
    vim.keymap.set("n", "<leader>Hd", function() gs.diffthis() end, { desc = "Diff this" })
  end
}
