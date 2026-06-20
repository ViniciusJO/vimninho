---@type PackitElement
return {
  {
    src = vim.pack.gh("m00qek/baleia.nvim"),
    tag = "v1.3.0",
    config = function() require("baleia").setup() end
  },
  {
    src = vim.pack.gh("ej-shafran/compile-mode.nvim"),
    config = function()
      ---@type CompileModeOpts
      vim.g.compile_mode = {
        input_word_completion = true,
        bang_expansion = true,
        use_diagnostics = true,
        -- to add ANSI escape code support, add:
        baleia_setup = true,
      }

      local cm = require('compile-mode')

      --- get_compile_buffer
      ---@return integer
      local function get_compilation_buffer()
        for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
          -- Check if the buffer is valid and loaded
          if vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted then
            local filetype = vim.bo[bufnr].filetype
            if filetype == 'compilation' then
              return bufnr -- Found a buffer with filetype 'compilation'
            end
          end
        end
        return -1 -- No buffer with filetype 'compilation' found
      end

      vim.keymap.set('n', '<leader>cc', function()
        local bufnr = get_compilation_buffer();
        if bufnr >= 0 then
          cm.recompile();
        else
          cm.compile();
          cm.send_to_qflist();
        end
      end, { desc = 'Compile mode' })

      vim.keymap.set('n', '<leader>cC', function()
        cm.compile();
        cm.send_to_qflist();
      end, { desc = 'Compile mode' })

      vim.keymap.set('n', ']e', function()
        local bufnr = get_compilation_buffer();
        vim.utils.do_in_other_buffer(bufnr, function()
          vim.o.cursorline = true;
          -- TODO: find a way to keep the compilation window oppened
          cm.move_to_next_error();
        end)
      end, { desc = 'Next compilation error' })

      vim.keymap.set('n', '[e', function()
        local bufnr = get_compilation_buffer();
        vim.utils.do_in_other_buffer(bufnr, function()
          vim.o.cursorline = true;
          -- TODO: find a way to keep the compilation window oppened
          cm.move_to_prev_error();
          -- cm.goto_error();
        end)
      end, { desc = 'Previous compilation error' })


      vim.keymap.set('n', '<leader>cnf', function()
        vim.cmd('CompileNextFile')
      end, { desc = 'Next file' })
      vim.keymap.set('n', '<leader>cne', function()
        vim.cmd('CompileNextError')
      end, { desc = 'Next error' })

      vim.keymap.set('n', '<leader>cpf', function()
        vim.cmd('CompilePrevFile')
      end, { desc = 'Previous file' })
      vim.keymap.set('n', '<leader>cpe', function()
        vim.cmd('CompilePrevError')
      end, { desc = 'Previous error' })


      vim.keymap.set('n', '<leader>cd', function()
        vim.cmd('CompileDebugError')
      end, { desc = 'Debug error' })
      vim.keymap.set('n', '<leader>cg', function()
        vim.cmd('CompileGotoError')
      end, { desc = 'Goto error' })
      vim.keymap.set('n', '<leader>ci', function()
        vim.cmd('CompileInterrupt')
      end, { desc = 'Interrupt' })
    end
  }

}
