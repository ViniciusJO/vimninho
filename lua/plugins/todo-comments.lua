---@type PackitElement
return {
  src = vim.pack.gh("folke/todo-comments.nvim"),
  config = function() require('todo-comments').setup() end,
}
