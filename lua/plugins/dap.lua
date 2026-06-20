---@type PackitElement
return {
  vim.pack.gh("rcarriga/nvim-dap-ui"),
  vim.pack.gh("igorlfs/nvim-dap-view"),
  vim.pack.gh("theHamsta/nvim-dap-virtual-text"),
  vim.pack.gh("nvim-neotest/nvim-nio"),
  vim.pack.gh("jay-babu/mason-nvim-dap.nvim"),
  vim.pack.gh("jbyuki/one-small-step-for-vimkind"),
  {
    src = vim.pack.gh("mfussenegger/nvim-dap"),
    config = function()
      local view = false
      local dap = require("dap")
      local dapui = view and require("dap-view") or require("dapui")
      -- local dapui = require('dapui')
      -- local dapview = require("dap-view")
      -- vim.print(dapview)

      require('nvim-dap-virtual-text').setup({})

      dap.adapters.cppdbg = {
        id = 'cppdbg',
        type = 'executable',
        command = '/usr/bin/gdb',
        args = { '-q' },
      }

      dap.configurations.c = {
        {
          name = "GDB launch file",
          type = "cppdbg",
          request = "launch",
          program = function()
            local inp = vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            -- vim.print("INPUT = ",inp)
            return inp
          end,
          cwd = '${workspaceFolder}',
          stopAtEntry = true,
        },
        {
          name = 'Attach to gdbserver :1234',
          type = 'cppdbg',
          request = 'launch',
          MIMode = 'gdb',
          miDebuggerServerAddress = 'localhost:1234',
          miDebuggerPath = '/usr/bin/gdb',
          cwd = '${workspaceFolder}',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
        },
      }

      dap.configurations.lua = {
        {
          type = 'nlua',
          request = 'attach',
          name = "Attach to running Neovim instance",
        }
      }

      dap.adapters.nlua = function(callback, config)
        callback({ type = 'server', host = config.host or "127.0.0.1", port = config.port or 8086 })
      end

      vim.keymap.set('n', '<leader>dl', function()
        require "osv".launch({ port = 8086 })
      end, { noremap = true, desc = "Launch lua debbuger" })

      vim.keymap.set('n', '<leader>dw', function()
        local widgets = require "dap.ui.widgets"
        widgets.hover()
      end, { desc = "Hover" })

      vim.keymap.set('n', '<leader>df', function()
        local widgets = require "dap.ui.widgets"
        widgets.centered_float(widgets.frames)
      end)

      -- dap.adapters["local-lua"] = {
      --   type = "executable",
      --   command = "node",
      --   args = {
      --     -- Absolute path to the compiled debugAdapter.js file
      --     vim.fn.expand("~/.local/share/nvim/mason/share/local-lua-debugger-vscode/extension/debugAdapter.js"),
      --   },
      --   enrich_config = function(config, on_config)
      --     if not config.extensionPath then
      --       local c = vim.deepcopy(config)
      --       -- CRITICAL: Without the correct extensionPath, you will hit "module 'lldebugger' not found" errors
      --       c.extensionPath = vim.fn.expand("~/.local/share/nvim/mason/share/local-lua-debugger-vscode/debugger/")
      --       -- c.extensionPath = vim.fn.expand("~/.local/share/nvim/debuggers/local-lua-debugger-vscode/")
      --       on_config(c)
      --     else
      --       on_config(config)
      --     end
      --   end,
      -- }
      --
      -- -- 2. Define the Configuration
      -- dap.configurations.lua = {
      --   {
      --     name = "Current file (local-lua-dbg)",
      --     type = "local-lua",
      --     request = "launch",
      --     cwd = "${workspaceFolder}",
      --     program = {
      --       lua = "lua", -- Change to "lua5.1" or "luajit" if your project demands it
      --       file = "${file}",
      --     },
      --     args = {},
      --   },
      -- }


      -- dap.configurations.c = dap.configurations.cpp

      -- require('mason-nvim-dap').setup {
      --   automatic_setup = true,
      --   automatic_installation = true,
      --   -- You can provide additional configuration to the handlers,
      --   -- see mason-nvim-dap README for more information
      --   handlers = {},
      --
      --   ensure_installed = {},
      -- }


      -- Basic debugging keymaps, feel free to change to your liking!
      vim.keymap.set('n', '<F1>', dap.continue, { desc = 'Debug: Start/Continue' })
      vim.keymap.set('n', '<F2>', dap.step_into, { desc = 'Debug: Step Into' })
      vim.keymap.set('n', '<F3>', dap.step_over, { desc = 'Debug: Step Over' })
      vim.keymap.set('n', '<F4>', dap.step_out, { desc = 'Debug: Step Out' })
      vim.keymap.set('n', '<F5>', dap.step_back, { desc = 'Debug: Step Back' })
      vim.keymap.set('n', '<F6>', dap.run_to_cursor, { desc = 'Debug: Run to cursor' })
      vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: Toggle UI' })
      -- vim.keymap.set('n', '<F7>', dapview.toggle, { desc = 'Debug: Toggle UI' })

      require('which-key').add({ { '<leader>d', desc = 'Debugger', noremap = true } })
      vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
      vim.keymap.set('n', '<leader>dB', function()
        dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end, { desc = 'Debug: Set Conditional Breakpoint' })
      -- vim.keymap.set('n', '<leader>dK', function()
      --   require('dapui').eval(nil, { enter = true })
      -- end, { desc = 'Debug: Eval under cursor' })
      -- TODO: implement eval under cursor

      -- require("which-key").register({
      --   ['<F5>'] = { dap.continue, 'Debug: Start/Continue' },
      --   ['<F1>'] = { dap.step_into, 'Debug: Step Into' },
      --   ['<F2>'] = { dap.step_over, 'Debug: Step Over' },
      --   ['<F3>'] = { dap.step_out, 'Debug: Step Out' },
      --   ['<leader>d'] = {
      --     name = 'Debug',
      --     b = { dap.toggle_breakpoint, 'Debug: Toggle Breakpoint' },
      --     B = { function()
      --       dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      --     end, 'Debug: Set Breakpoint' },
      --   },
      --   ['<F7>'] = { dapui.toggle, 'Debug: See last session result.' },
      -- })

      -- vim.highlight.create('DapBreakpoint', { ctermbg=0, guifg='#993939', guibg='#31353f' }, false)
      -- vim.highlight.create('DapLogPoint', { ctermbg=0, guifg='#61afef', guibg='#31353f' }, false)
      -- vim.highlight.create('DapStopped', { ctermbg=0, guifg='#98c379', guibg='#31353f' }, false)

      vim.fn.sign_define('DapBreakpoint', {
        text = '',
        texthl = 'DapBreakpoint',
        linehl = 'DapBreakpoint',
        numhl = 'DapBreakpoint'
      })
      vim.fn.sign_define('DapBreakpointCondition',
        { text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
      vim.fn.sign_define('DapBreakpointRejected',
        { text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
      vim.fn.sign_define('DapLogPoint',
        { text = '', texthl = 'DapLogPoint', linehl = 'DapLogPoint', numhl = 'DapLogPoint' })
      vim.fn.sign_define('DapStopped', { text = '', texthl = 'DapStopped', linehl = 'DapStopped', numhl = 'DapStopped' })

      -- dapview.setup()
      dapui.setup()
    end
  },
}
