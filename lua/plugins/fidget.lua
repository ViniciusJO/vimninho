---@type PackitElement
return {
  src = vim.pack.gh("j-hui/fidget.nvim"),
  config = function()
    require("fidget").setup()
  end
}
