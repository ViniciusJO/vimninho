---@type PackitElement
return {
  vim.pack.gh("mason-org/mason.nvim"),
  vim.pack.gh("mason-org/mason-lspconfig.nvim"),
  vim.pack.gh("folke/lazydev.nvim"),
  vim.pack.gh("ziglang/zig.vim"),
  vim.pack.gh("marilari88/twoslash-queries.nvim"),
  {
    src = vim.pack.gh("neovim/nvim-lspconfig"),
    config = function()
      local lsp_augroup = vim.api.nvim_create_augroup("CustomLspConfig", { clear = true })

      require("mason").setup()
      local mason_lspconfig = require('mason-lspconfig')
      mason_lspconfig.setup()

      require('twoslash-queries').setup({
        multi_line = true,  -- to print types in multi line mode
        is_enabled = true,  -- to keep disabled at startup and enable it on request with the TwoslashQueriesEnable
        highlight = "Type", -- to set up a highlight group for the virtual text
      })
      vim.lsp.config("ts_ls", {
        on_attach = function(client, bufnr)
          local tsq = require("twoslash-queries")
          tsq.attach(client, bufnr)
          vim.keymap.set('n', '<leader>l//', '<cmd>TwoslashQueriesInspect<cr>',
            { desc = 'Inspect', noremap = true, silent = true, buffer = bufnr })
          vim.keymap.set('n', '<leader>l/t', function()
            if tsq.config.is_enabled then
              tsq.disable()
            else
              tsq.enable()
            end
          end, { desc = 'Toggle', noremap = true, silent = true, buffer = bufnr })
        end
      })


      local diagnostic_signs = {
        Error = " ",
        Warn = " ",
        Hint = "",
        Info = "",
      }

      vim.diagnostic.config({
        virtual_text = { prefix = "●", spacing = 4 },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = diagnostic_signs.Error,
            [vim.diagnostic.severity.WARN] = diagnostic_signs.Warn,
            [vim.diagnostic.severity.HINT] = diagnostic_signs.Hint,
            [vim.diagnostic.severity.INFO] = diagnostic_signs.Info,
          },
        },
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
          -- source = "always",
          header = "",
          prefix = "",
          focusable = false,
          style = "minimal",
        },
      })

      require("lazydev").setup({
        library = {
          { path = "${3rd}/luv/library",        words = { "vim%.uv" } },
          { path = "wezterm-types",             mods = { "wezterm" } },
          { path = "xmake-luals-addon/library", files = { "xmake.lua" } },
        },
        enabled = function(root_dir)
          local _ = root_dir;
          return vim.g.lazydev_enabled == nil and true or vim.g.lazydev_enabled
        end,
      })


      local function lsp_on_attach(ev)
        if not ev.data then return; end
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if not client then return; end

        local bufnr = ev.buf
        local opts = { noremap = true, silent = true, buffer = bufnr }
        local buf = vim.lsp.buf

        vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, { desc = 'Type Definition' })

        vim.keymap.set('n', '<leader>lf', buf.format, { desc = 'Format' })
        vim.keymap.set('n', '<leader>lr', buf.rename, { desc = 'Rename' })
        vim.keymap.set('n', '<leader>la', buf.code_action, { desc = 'Code Actions' })


        vim.keymap.set('n', '<leader>lsd', function()
          vim.cmd("split")
          buf.definition()
        end, { desc = 'Goto Definition' })
        vim.keymap.set('n', '<leader>lvd', function()
          vim.cmd("vsplit")
          buf.definition()
        end, { desc = 'Goto Definition' })

        vim.keymap.set('n', '<leader>lR', ':LspRestart<cr>', { desc = 'Restart LSP' })

        vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, { desc = 'Workspace Add Folder' })
        vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, { desc = 'Workspace Remove Folder' })
        vim.keymap.set('n', '<leader>ww', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
          { desc = 'Workspace List Folders' })

        vim.keymap.set('n', '<leader>gd', buf.definition, { desc = 'Goto Definition' })
        vim.keymap.set('n', '<leader>gD', vim.lsp.buf.declaration, { desc = 'Goto Declaration' })
        vim.keymap.set('n', '<leader>gI', buf.implementation, { desc = 'Goto Implementation' })
        vim.keymap.set('n', 'gd', buf.definition, { desc = 'Goto Definition' })
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = 'Goto Declaration' })
        vim.keymap.set('n', 'gI', buf.implementation, { desc = 'Goto Implementation' })

        -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Hover Documentation' })
        vim.keymap.set('i', '<C-\\>', vim.lsp.buf.signature_help, { desc = 'Signature Documentation' })

        -- if client.server_capabilities["documentSymbolProvider"] then
        --   require("nvim-navic").attach(client, bufnr)
        -- end

        -- Create a command `:Format` local to the LSP buffer
        vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
          vim.lsp.buf.format()
        end, { desc = 'Format current buffer with LSP' })

        vim.keymap.set("n", "<leader>fd", function()
          vim.utils.finder.lsp_definitions({ jump_to_single_result = true })
        end, vim.tbl_extend("force", opts, {desc = "LSP Definitions"}))
        vim.keymap.set("n", "<leader>fr", vim.utils.finder.lsp_references, vim.tbl_extend("force", opts, {desc = "LSP References"}) )
        vim.keymap.set("n", "<leader>ft", vim.utils.finder.lsp_typedefs, vim.tbl_extend("force", opts, {desc = "LSP Typedefs"}))
        vim.keymap.set("n", "<leader>fs", vim.utils.finder.lsp_document_symbols, vim.tbl_extend("force", opts, {desc = "LSP Document Symbols"}))
        vim.keymap.set("n", "<leader>fw", vim.utils.finder.lsp_workspace_symbols, vim.tbl_extend("force", opts, {desc = "LSP Workspace Symbols"}))
        vim.keymap.set("n", "<leader>fi", vim.utils.finder.lsp_implementations, vim.tbl_extend("force", opts, {desc = "LSP Implementations"}))
      end

      vim.api.nvim_create_autocmd("LspAttach", { group = lsp_augroup, callback = lsp_on_attach })

      local servers = {
        clangd = {
          cmd = { "clangd", "--compile-commands-dir=." },
        },
        lua_ls = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
            telemetry = { enable = false }
          }
        },
      }

      vim.lsp.config("*", { on_attach = lsp_on_attach })

      for sname, sconfig in pairs(servers) do
        vim.lsp.config(sname, sconfig)
      end

      local function keys(tbl)
        local ks = {}
        for k in pairs(tbl) do table.insert(ks, k) end
        return ks;
      end

      local srvs = vim.tbl_extend('force', keys(servers), mason_lspconfig.get_installed_servers())
      vim.lsp.enable(srvs);

      -- mason_lspconfig.setup_handlers({
      --   function(server_name)
      --     vim.print(server_name)
      --     vim.lsp.config(server_name, {
      --       settings = servers[server_name],
      --       filetypes = (servers[server_name] or {}).filetypes,
      --     });
      --     vim.lsp.enable(server_name);
      --   end
      -- })

      vim.keymap.set("n", "<leader>lq", function()
        vim.diagnostic.setloclist({ open = true })
      end, { desc = "Open diagnostic list" })
      vim.keymap.set("n", "<leader>ll", vim.diagnostic.open_float, { desc = "Show line diagnostics" })

      vim.g.zig_fmt_autosave = 0
    end,
  },
}
