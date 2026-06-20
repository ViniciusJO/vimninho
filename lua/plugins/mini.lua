---@type Packit
return {
  src = vim.pack.gh("echasnovski/mini.nvim"),
  config = function()
    require("mini.ai").setup()
    require("mini.comment").setup()
    require("mini.move").setup()
    -- require("mini.cursorword").setup()
    -- require("mini.indentscope").setup()
    require("mini.pairs").setup()
    require("mini.trailspace").setup()
    local bremove = require("mini.bufremove")
    bremove.setup()

    vim.keymap.set("n", "<leader>bd", function() bremove.delete(0,false) end, { desc = "Buf delete", noremap = true })
    -- vim.keymap.set("n", "<leader>bd", "<cmd>bd<cr>", { desc = "Buf delete", noremap = true })

    require("mini.notify").setup()
    require("mini.icons").setup()
    require("mini.surround").setup()
    require("mini.align").setup({ mappings = { start = '<leader>+', start_with_preview = '<leader>=' } })
    require('mini.tabline').setup({
      show_icons = false,
      format = function(buf_id, label)
        local default_label = MiniTabline.default_format(buf_id, label)
        if vim.bo[buf_id].modified then return '[' .. default_label .. ']' end
        return default_label
      end
    })

    local function reset_tabline_modified_styles()
      vim.api.nvim_set_hl(0, 'minitablinemodifiedcurrent', { link = 'minitablinecurrent' })
      vim.api.nvim_set_hl(0, 'minitablinemodifiedvisible', { link = 'minitablinevisible' })
      vim.api.nvim_set_hl(0, 'minitablinemodifiedhidden',  { link = 'minitablinehidden'  })
    end
    reset_tabline_modified_styles()
    vim.api.nvim_create_autocmd('ColorScheme', { callback = reset_tabline_modified_styles })
  end
}
