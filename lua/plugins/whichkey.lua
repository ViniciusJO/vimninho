---@type Packit
return {
  src = vim.pack.gh("folke/which-key.nvim"),
  config = function()
    local wk = require('which-key');
    wk.setup()

    ---Hints a intermediary keymap prefix
    ---@param prefix string Prefix of the mapping.
    ---@param hint string Hint
    ---@diagnostic disable-next-line: duplicate-set-field
    function vim.keymap.hint(prefix, hint)
      wk.add({{ prefix, desc = hint }})
    end
  end
}
