---@type PackitElement
return {
  src = vim.pack.gh("A7Lavinraj/fyler.nvim"),
  config = function()
    local fyler = require("fyler");
    ---@diagnostic disable: missing-fields
    fyler.setup({
      integrations = { icon = "nvim_web_devicons", },
      views = { finder = {
        git_status = { enabled = true, symbols = { Untracked = "?", Added = "+", Modified = "*", Deleted = "x", Renamed = ">", Copied = "~", Conflict = "!", Ignored = "#", } },
        close_on_select = true,
        confirm_simple = false,
        default_explorer = true,
        delete_to_trash = true,
        columns = {
          git = {
            enabled = true,
            symbols = { Untracked = "?", Added = "+", Modified = "*", Deleted = "x", Renamed = ">", Copied = "~", Conflict = "!", Ignored = "#", },
          },
        },
        icon = {
          directory_collapsed = nil,
          directory_empty = nil,
          directory_expanded = nil,
        },
        indentscope = {
          enabled = true,
          group = "FylerIndentMarker",
          markers = "│",
        },
        mappings = {
          ["q"] = "CloseView",
          ["<CR>"] = "Select",
          ["<C-t>"] = "SelectTab",
          ["|"] = "SelectVSplit",
          ["-"] = "SelectSplit",
          ["^"] = "GotoParent",
          ["="] = "GotoCwd",
          ["."] = "GotoNode",
          ["#"] = "CollapseAll",
          ["<BS>"] = "CollapseNode",
        },
        mappings_opts = {
          nowait = false,
          noremap = true,
          silent = true,
        },
        follow_current_file = true,
        watcher = { enabled = false, },
        win = {
          border = vim.o.winborder == "" and "single" or vim.o.winborder,
          buf_opts = {
            filetype = "fyler",
            syntax = "fyler",
            buflisted = false,
            buftype = "acwrite",
            expandtab = true,
            shiftwidth = 2,
          },
          kind = "replace",
          kinds = {
            float = {
              height = "70%",
              width = "70%",
              top = "10%",
              left = "15%",
            },
            replace = {},
            split_above = { height = "70%", },
            split_above_all = {
              height = "70%",
              win_opts = {
                winfixheight = true,
              },
            },
            split_below = {
              height = "70%",
            },
            split_below_all = {
              height = "70%",
              win_opts = {
                winfixheight = true,
              },
            },
            split_left = {
              width = "30%",
            },
            split_left_most = {
              width = "30%",
              win_opts = { winfixwidth = true, },
            },
            split_right = {
              width = "30%",
            },
            split_right_most = {
              width = "30%",
              win_opts = {
                winfixwidth = true,
              },
            },
          },
          win_opts = {
            concealcursor = "nvic",
            conceallevel = 3,
            cursorline = false,
            number = false,
            relativenumber = false,
            winhighlight = "Normal:FylerNormal,NormalNC:FylerNormalNC",
            wrap = false,
            signcolumn = "yes",
          },
        }
      } }
      ---@diagnostic enable: missing-fields
    })


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


  end
}
