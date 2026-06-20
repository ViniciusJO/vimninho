local function cpp_mangling_prevention_mechanism()
  return "#ifdef __cplusplus\r"
      .. "extern \"C\" {\r"
      .. "#endif//__cplusplus\r\r\r\r"
      .. "#ifdef __cplusplus\r"
      .. "}\r"
      .. "#endif//__cplusplus\r"
end

local function c_header_guard(name)
  return "#ifndef __" .. name .. "_H__\r"
      .. "#define __" .. name .. "_H__\r"
      .. cpp_mangling_prevention_mechanism()
      .. "#endif//__" .. name .. "_H__\r"
      .. "\r"
end

local function c_header_only_imp(name)
  return "//#define " .. name .. "_IMPLEMENTATIONS\r"
      .. "#ifdef " .. name .. "_IMPLEMENTATIONS\r"
      .. "#ifndef __" .. name .. "_IMP__\r"
      .. "#define __" .. name .. "_IMP__\r"
      .. cpp_mangling_prevention_mechanism()
      .. "#endif//__" .. name .. "_IMP__\r"
      .. "#undef ".. name .. "_IMPLEMENTATIONS\r"
      .. "#endif//" .. name .. "_IMPLEMENTATIONS\r"
      .. "\r"
end

local M = {}

M.not_c_msg = "Not a C translation unity or a header file"

function M.generate_c_header_only_preprocs()
  local current_file = vim.fn.expand('%:p')

  if not current_file:match('%.c$') and not current_file:match('%.h$') then
    -- print(current_file..": "..M.not_c_msg)
    vim.api.nvim_echo({ { current_file..": "..M.not_c_msg, "DiagnosticError" } }, true, {})
    return
  end

  local linen = vim.fn.line('.')
  local line_content = vim.fn.getline(linen)
  local filepath = vim.api.nvim_buf_get_name(0)
---
  local filename = vim.fn.fnamemodify(filepath, ":t:r")
  local h_name = filename:upper()

  local preproc_thing = c_header_guard(h_name) .. c_header_only_imp(h_name)

  local lines = vim.split(preproc_thing, "\r")

  while '' == lines[1] do table.remove(lines, 1) end
  if lines[#lines] == "" then table.remove(lines, #lines) end

  vim.utils.append_multiline(lines, linen)
  if line_content == '' or line_content == '\r' then
    vim.utils.remove_line_from_buffer(linen)
  end
end

function M.preprocessCFile()
  local current_file = vim.fn.expand('%:p')

  if not current_file:match('%.c$') and not current_file:match('%.h$') then
    -- print(current_file..": "..M.not_c_msg)
    vim.api.nvim_echo({ { current_file..": "..M.not_c_msg, "DiagnosticError" } }, true, {})
    return
  end

  vim.notify("Preprocessing...", vim.log.levels.INFO, { title = "PreprocessCFile" })

  local command = vim.fn.input('Preprocess cmd: ', 'cpp '..current_file, 'file')
  local output = vim.fn.system(command..' 2>&1 | grep --invert-match "^#" | clang-format | sed \'/./,/^$/!d; /^$/N;/\\n$/D\'')

  vim.cmd('new')        -- Open a new buffer
  vim.bo.filetype = 'c' -- Set filetype to C
  vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(output, "\n"))
  vim.cmd('setlocal buftype=nofile') -- Set buffer as not a file
end

-- function M.setup()
--   vim.api.nvim_create_user_command('CHeaderThing', M.generate_c_header_only_preprocs, { desc = 'Execute command in place' })
--   -- require('which-key').add({ '<leader>L', desc = "Source" })
--   vim.keymap.set({ 'n' }, '<leader>Ll', ':source %<CR>', { desc = 'Source current file' })
--   vim.keymap.set({ 'n' }, '<leader>LL', ':source ~/.config/nvim/init.lua<CR>', { desc = 'Source global config' })
--
--   vim.api.nvim_create_user_command('PreprocessC', M.preprocessCFile, {})
--   vim.keymap.set('n', '<leader>lp', M.preprocessCFile, { desc = 'Preprocess C File' })
-- end

return M
