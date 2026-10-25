---@type PackitElement
return {
  src = vim.pack.gh("sampsn/pair.nvim"),
  config = function()
    require("pair").setup({
      backend = "opencode",
      command = vim.fn.expand("~/.local/bin/oc"),
    })
  end
}
