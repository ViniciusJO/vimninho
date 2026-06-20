---@type PackitElement
return {
  src = vim.pack.gh("stevearc/aerial.nvim"),
  config = function()
    require("aerial").setup({
      on_attach = function(bufnr)
        vim.keymap.set("n", "<leader>a{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
        vim.keymap.set("n", "<leader>a}", "<cmd>AerialNext<CR>", { buffer = bufnr })
      end,
    })
    vim.keymap.set("n", "<leader>aa", "<cmd>AerialToggle!<CR>")
  end
}
