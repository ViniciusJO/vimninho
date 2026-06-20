---@type PackitElement
return {
  src = vim.pack.gh("goolord/alpha-nvim"),
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    dashboard.section.header.val = {
      "██╗   ██╗██╗███╗   ███╗███╗   ██╗██╗███╗   ██╗██╗  ██╗ ██████╗ ",
      "██║   ██║██║████╗ ████║████╗  ██║██║████╗  ██║██║  ██║██╔═══██╗",
      "██║   ██║██║██╔████╔██║██╔██╗ ██║██║██╔██╗ ██║███████║██║   ██║",
      "╚██╗ ██╔╝██║██║╚██╔╝██║██║╚██╗██║██║██║╚██╗██║██╔══██║██║   ██║",
      " ╚████╔╝ ██║██║ ╚═╝ ██║██║ ╚████║██║██║ ╚████║██║  ██║╚██████╔╝",
      "  ╚═══╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═══╝╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝ ╚═════╝ ",
    }

    for _ = 1, (vim.api.nvim_win_get_height(0) - 2) / 2 - 3, 1 do
      table.insert(dashboard.section.header.val, 0, "")
    end

    dashboard.section.buttons.val = {}

    alpha.setup(dashboard.opts)

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "alpha",
      callback = function()
        -- local opts = { buffer = true }
        vim.opt_local.foldenable = false
        vim.opt_local.modifiable = false
        vim.opt_local.readonly = true
        vim.opt_local.buftype = "nofile"
        vim.opt_local.bufhidden = "wipe"

        -- Disable key movements
        local keys = { "h", "j", "k", "l", "gg", "G", "<C-d>", "<C-u>", "<Up>", "<Down>", "<Left>", "<Right>", "n", "N",
          "/", "?", "w", "W", "b", "B", "e", "E", "f", "F", "t", "T" }
        for _, key in ipairs(keys) do vim.keymap.set("n", key, "<Nop>", { buffer = true }) end
      end,
    })

    ---@diagnostic disable-next-line: duplicate-set-field
    function vim.utils.intro()
      vim.cmd("Alpha");
    end
  end
}
