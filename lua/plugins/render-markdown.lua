---@type PackitElement
return {
  src = vim.pack.gh("MeanderingProgrammer/render-markdown.nvim"),
  config = function() require('render-markdown').setup() end,
}
