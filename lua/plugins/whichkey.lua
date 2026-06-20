---@type Packit
return {
  src = vim.pack.gh("folke/which-key.nvim"),
  config = function()
    local wk = require('which-key');
    wk.setup()

    function vim.keymap.hint(prefix, hint)
      wk.add({{ prefix, desc = hint }})
    end
  end
}
