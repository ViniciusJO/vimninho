---@type PackitElement
return {
  src = vim.pack.gh("catgoose/nvim-colorizer.lua.git"),
  config = function()
    -- #C01092
    -- Cyan
    require("colorizer").setup({
      options = {
        parsers = { css_fn = true, css_variables = true, rgb = { enable = true } },
      },
    })
  end
}
