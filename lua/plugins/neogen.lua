---@type PackitElement
return {
  src = vim.pack.gh("danymat/neogen"),
  config = function()
    local neogen = require('neogen')
    neogen.setup({})
    vim.keymap.set("n", "<leader>o", neogen.generate, { noremap = true, silent = true, desc = "Neogen generate" })
  end
}
