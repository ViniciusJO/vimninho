---@type Packit
return {
  src = vim.pack.gh("ibhagwan/fzf-lua"),
  config = function()
    local fzf_lua = require("fzf-lua")
    local fzf_actions = require("fzf-lua.actions")
    fzf_lua.setup({})
    vim.keymap.set("n", "<leader>fo", fzf_lua.oldfiles, { desc = "Files" })
    vim.keymap.set("n", "<leader>ff", fzf_lua.files, { desc = "Files" })
    vim.keymap.set("n", "<leader>fl", fzf_lua.live_grep, { desc = "Diagnostics Workspace" })
    vim.keymap.set("n", "<leader>fg", fzf_lua.live_grep, { desc = "Live Grep" })
    vim.keymap.set("n", "<leader>fb", fzf_lua.buffers, { desc = "Buffers" })
    vim.keymap.set("n", "<leader>fh", fzf_lua.help_tags, { desc = "Help Tags" })
    vim.keymap.set("n", "<leader>fx", fzf_lua.diagnostics_document, { desc = "Diagnostics Document" })
    vim.keymap.set("n", "<leader>fX", fzf_lua.diagnostics_workspace, { desc = "Diagnostics Workspace" })
    -- vim.keymap.set("n", "<leader>fc", fzf_lua.colorschemes, { desc = "Colorscheme" })
    vim.keymap.set("n", "<leader>fc", function()
      fzf_lua.colorschemes({
        actions = {
          ["default"] = function(selected, opts)
            fzf_actions.colorscheme(selected, opts)
            local theme_name = selected[1]
            vim.utils.run_cmd_capture('!echo \'vim.cmd.colorscheme(\"' .. theme_name .. '\")\' >> ' .. vim.g.runtimepath .. '/colorscheme.lua')
          end
        }
      })
      -- print("HELLO")
    end , { desc = "Colorscheme" })

-- :lua print('vim.cmd.colorscheme("'..vim.g.colors_name..'")')

    vim.utils.finder = fzf_lua
  end
}
