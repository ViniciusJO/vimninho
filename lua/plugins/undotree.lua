---@type Packit
return {
  src = vim.pack.gh("jiaoshijie/undotree"),
  config = function()
    require("undotree").setup()
    vim.keymap.set('n', '<leader>u', require('undotree').toggle, { desc = 'Undotree Toggle' })
  end
}
