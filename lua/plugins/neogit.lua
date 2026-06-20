---@type PackitElement
return {
  { src = vim.pack.gh("sindrets/diffview.nvim"), config = function() require("diffview").setup() end },
  {
    src = vim.pack.gh("NeogitOrg/neogit"),
    config = function()
      local neogit = require("neogit")
      neogit.setup({})
      vim.keymap.set({ "n", "v" }, "<leader>n", neogit.open, --[[":Neogit<cr>",]] { desc = "Neogit", noremap = true, silent = true })
    end
  },
}
