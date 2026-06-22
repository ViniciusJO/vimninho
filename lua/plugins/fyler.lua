---@type PackitElement
return {
  src = vim.pack.gh("A7Lavinraj/fyler.nvim"),
  config = function()
    local fyler = require("fyler")
    -- vim.print("<================>")
    ---@diagnostic disable: missing-fields
    fyler.setup({
      extensions = {
        git = { enabled = true, inline = false, },
        trash = { enabled = true }
      },
      -- integrations = { icon = "nvim_web_devicons", },
      integrations = { icon = "mini_icons", },
      kind = 'replace',
      -- kind_presets = {
      --   floating = { border = 'single', height = '80%', width = '60%', col = 'center', row = 'center', },
      --   split_above = { height = '50%' },
      --   split_above_all = { height = '50%' },
      --   split_below = { height = '50%' },
      --   split_below_all = { height = '50%' },
      --   split_left = { width = '25%' },
      --   split_left_most = { width = '25%' },
      --   split_right = { width = '25%' },
      --   split_right_most = { width = '25%' },
      -- },
      mappings = {
        n = {
          ['.'] = { action = 'visit', args = { cursor = true } },
          ['<BS>'] = { action = 'visit', args = { parent = true } },
          ['_'] = { action = 'shrink', args = { parent = true } },
          ['<C-R>'] = { action = 'refresh' },
          ['<C-T>'] = { action = 'select', args = { tabedit = true } },
          ['-'] = { action = 'select', args = { split = true } },
          ['|'] = { action = 'select', args = { vsplit = true } },
          ['<CR>'] = { action = 'select' },
          ['='] = { action = 'visit' },
          ['g.'] = { action = 'toggle_ui', args = { 'hidden_items' } },
          ['gi'] = { action = 'toggle_ui', args = { 'indent_guides' } },
          ['q'] = { action = 'close' },
          ['<C-S>'] = { action = 'none' },
          ['<C-V>'] = { action = 'none' },
        },
      },
      ui = {
        hidden_items = { switches = {}, patterns = {}, always_visible = {}, always_hidden = {} },
        indent_guides = true,
      },
    })
    -- vim.keymap.set("n", "<C-S>", "<cmd>w<cr>", { noremap = true, silent = false })

    vim.keymap.set("n", "<leader>e", function()
      if vim.utils.is_intro_buffer() then
        fyler.toggle({ kind = "replace" });
      elseif vim.bo.filetype ~= "fyler" then
        fyler.toggle({ kind = "split_left_most" });
      elseif #vim.api.nvim_tabpage_list_wins(0) > 1 then
        fyler.toggle({ kind = "split_left_most" });
      else
        vim.utils.intro()
      end
    end, { desc = "Open Fyler explorer", silent = true, noremap = true })

    -- vim.api.nvim_create_autocmd("VimEnter", {
    --   callback = function()
    --     local args = vim.fn.argv()
    --     local is_dir = (#args == 1) and vim.fn.isdirectory(args[1]) == 1
    --     if is_dir then
    --       vim.api.nvim_set_current_dir(args[1])
    --       fyler.open({ kind = "replace" })
    --       vim.bo.buflisted = false;
    --     end
    --   end,
    -- })

    -- vim.api.nvim_set_hl(0, "NvimTreeNormalNC", { bg = "none" })
    -- vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
    -- vim.api.nvim_set_hl(0, "NvimTreeSignColumn", { bg = "none" })
    -- vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = "none" })
    -- vim.api.nvim_set_hl(0, "NvimTreeWinSeparator", { fg = "#2a2a2a", bg = "none" })
    -- vim.api.nvim_set_hl(0, "NvimTreeEndOfBuffer", { bg = "none" })




    -- if false then
    --   fyler.setup({
    --     views = {
    --       finder = {
    --         git_status = { enabled = true, symbols = { Untracked = "?", Added = "+", Modified = "*", Deleted = "x", Renamed = ">", Copied = "~", Conflict = "!", Ignored = "#", } },
    --         close_on_select = true,
    --         confirm_simple = false,
    --         default_explorer = true,
    --         delete_to_trash = true,
    --         columns = {
    --           git = {
    --             enabled = true,
    --             symbols = { Untracked = "?", Added = "+", Modified = "*", Deleted = "x", Renamed = ">", Copied = "~", Conflict = "!", Ignored = "#", },
    --           },
    --         },
    --         icon = {
    --           directory_collapsed = nil,
    --           directory_empty = nil,
    --           directory_expanded = nil,
    --         },
    --         indentscope = {
    --           enabled = true,
    --           group = "FylerIndentMarker",
    --           markers = "│",
    --         },
    --         mappings = {
    --           ['.'] = { action = 'visit', args = { cursor = true } },
    --           ['<BS>'] = { action = 'visit', args = { parent = true } },
    --           ['_'] = { action = 'shrink', args = { parent = true } },
    --           ['<C-R>'] = { action = 'refresh' },
    --           ['<C-T>'] = { action = 'select', args = { tabedit = true } },
    --           ['-'] = { action = 'select', args = { split = true } },
    --           ['|'] = { action = 'select', args = { vsplit = true } },
    --           ['<CR>'] = { action = 'select' },
    --           ['='] = { action = 'visit' },
    --           ['g.'] = { action = 'toggle_ui', args = { 'hidden_items' } },
    --           ['gi'] = { action = 'toggle_ui', args = { 'indent_guides' } },
    --           ['q'] = { action = 'close' },
    --           -- ["q"] = "CloseView",
    --           -- ["<CR>"] = "Select",
    --           -- ["<C-t>"] = "SelectTab",
    --           -- ["|"] = "SelectVSplit",
    --           -- ["-"] = "SelectSplit",
    --           -- ["^"] = "GotoParent",
    --           -- ["="] = "GotoCwd",
    --           -- ["."] = "GotoNode",
    --           -- ["#"] = "CollapseAll",
    --           -- ["<BS>"] = "CollapseNode",
    --         },
    --         -- indent_guides = true,
    --         mappings_opts = {
    --           nowait = false,
    --           noremap = false,
    --           silent = true,
    --         },
    --         follow_current_file = true,
    --         watcher = { enabled = false, },
    --         win = {
    --           border = vim.o.winborder == "" and "single" or vim.o.winborder,
    --           buf_opts = {
    --             filetype = "fyler",
    --             syntax = "fyler",
    --             buflisted = false,
    --             buftype = "acwrite",
    --             expandtab = true,
    --             shiftwidth = 2,
    --           },
    --           kind = "replace",
    --           kinds = {
    --             float = {
    --               height = "70%",
    --               width = "70%",
    --               top = "10%",
    --               left = "15%",
    --             },
    --             replace = {},
    --             split_above = { height = "70%", },
    --             split_above_all = {
    --               height = "70%",
    --               win_opts = {
    --                 winfixheight = true,
    --               },
    --             },
    --             split_below = {
    --               height = "70%",
    --             },
    --             split_below_all = {
    --               height = "70%",
    --               win_opts = {
    --                 winfixheight = true,
    --               },
    --             },
    --             split_left = {
    --               width = "30%",
    --             },
    --             split_left_most = {
    --               width = "30%",
    --               win_opts = { winfixwidth = true, },
    --             },
    --             split_right = {
    --               width = "30%",
    --             },
    --             split_right_most = {
    --               width = "30%",
    --               win_opts = {
    --                 winfixwidth = true,
    --               },
    --             },
    --           },
    --           win_opts = {
    --             concealcursor = "nvic",
    --             conceallevel = 3,
    --             cursorline = false,
    --             number = false,
    --             relativenumber = false,
    --             winhighlight = "Normal:FylerNormal,NormalNC:FylerNormalNC",
    --             wrap = false,
    --             signcolumn = "yes",
    --           },
    --         }
    --       }
    --     }
    --   })
    -- end
  end
}
