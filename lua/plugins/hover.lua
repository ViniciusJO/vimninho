---@type PackitElement
return {
  src = vim.pack.gh("lewis6991/hover.nvim"),
  config = function()
    local hover = require("hover")
    hover.config({
      init = function()
        require("hover.providers.lsp")
        require('hover.providers.dap')
        -- require('hover.providers.fold_preview')
        require('hover.providers.diagnostic')
        require('hover.providers.man')
        -- require('hover.providers.dictionary')
      end,
      preview_opts = { border = 'single' },
      preview_window = false,
      title = true,
      mouse_providers = { 'LSP' },
      mouse_delay = 1000
    })
    vim.keymap.set("n", "K", hover.open, { desc = "Hover Documentation" })
    vim.keymap.set("n", "gK", hover.select, { desc = "Hover Documentation (select)" })
    vim.keymap.set("n", "<C-p>", function() hover.switch("previous") end,
      { desc = "Hover Documentation (previous source)" })
    vim.keymap.set("n", "<C-n>", function() hover.switch("next") end,
      { desc = "Hover Documentation (next source)" })
  end,
}
