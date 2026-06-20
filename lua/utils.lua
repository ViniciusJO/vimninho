if not vim.utils then vim.utils = {} end

---Looks for the last match of `pattern` in the string, return the start and the end indexes.
---@param str string
---@param substr string
---@return number?, number?
function vim.utils.rfind(str, substr)
    if str == nil then return nil end
    local last_start, last_end
    local start = 1

    while true do
        local s, e = str:find(substr, start, true)
        if not s then break end

        last_start, last_end = s, e
        start = s + 1
    end

    return last_start, last_end
end

---Print information about the char under the cursor
function vim.utils.print_current_char_code()
  local line_number = vim.fn.line('.')
  local column_number = vim.fn.col('.')

  local line_content = vim.fn.getline(line_number)
  local char = line_content:sub(column_number, column_number)
  local char_code = string.byte(char)
  print("Character code: '" .. char .. "' = " .. char_code .. " (" .. string.format("0x%X", char_code) .. ", " .. string.format("0%o", char_code) .. ")")
end

---Append multi lines at position
---@param lines table<string>
---@param position integer
function vim.utils.append_multiline(lines, position)
  local buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_lines(buf, position, position, false, lines)
end

---Append indented multi lines at position
---@param lines table<string>
---@param position integer
---@param indent integer
function vim.utils.append_multiline_indent(lines, position, indent)
  local padding = ""
  for _ = 1, indent, 1 do padding = padding .. " " end
  local indented_lines = {}
  for _, line in ipairs(lines) do
    table.insert(indented_lines, padding .. line)
  end
  vim.utils.append_multiline(indented_lines, position)
end

---Remove line from buffer
---@param line_number integer
function vim.utils.remove_line_from_buffer(line_number)
  local buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_lines(buf, line_number - 1, line_number, false, {})
end

---Count string leading spaces
---@param str string
---@return integer
function vim.utils.count_leading_spaces(str)
  local count = 0
  for i = 1, #str do
    if str:sub(i, i) == " " then
      count = count + 1
    else
      break
    end
  end
  return count
end
---
---@param bufnr_to_find integer
---@return boolean
function vim.utils.jump_to_buffer_in_window(bufnr_to_find)
  local all_tabpages = vim.api.nvim_list_tabpages()

  for _, tabpage in ipairs(all_tabpages) do
    local win_list = vim.api.nvim_tabpage_list_wins(tabpage)
    for _, win_id in ipairs(win_list) do
      local current_buf_in_win = vim.api.nvim_win_get_buf(win_id)
      if current_buf_in_win == bufnr_to_find then
        vim.api.nvim_set_current_win(win_id)
        return true -- Buffer found and jumped to
      end
    end
  end
  return false -- Buffer not found in any window
end

--- Exec function in other buffer
---@param bufnr integer
---@param fn function
function vim.utils.do_in_other_buffer(bufnr, fn, report)
  local cb = vim.api.nvim_get_current_buf();
  if bufnr >= 0 then
    vim.utils.jump_to_buffer_in_window(bufnr);
    fn();
    vim.utils.jump_to_buffer_in_window(cb);
  elseif report then
    error("Buffer " .. bufnr .. " not found");
  end
end


---Hints a intermediary keymap prefix
---@param prefix string Prefix of the mapping.
---@param hint string Hint
---@diagnostic disable-next-line: duplicate-set-field
---@diagnostic disable-next-line: duplicate-set-field
function vim.keymap.hint(prefix, hint)
  vim.keymap.set("*", prefix, "<Nop>", { desc = hint })
end









---Returns github url to repository
---@param repo string repository in the form `user/repo`
---@return string github url to repository
function vim.pack.gh(repo) return "https://github.com/" .. repo; end

---@class Packit: vim.pack.Spec
---@field config ?fun()

---@alias PackitParams (string|Packit)
---@alias PackitArray PackitParams[]

---@alias PackitElement (PackitParams|PackitArray)
---@alias PackitList PackitElement[]


---
---@param list PackitList
---@param tbl ?PackitArray
---@return PackitArray
function vim.pack.packit_flatten(list,tbl)
  if not tbl then tbl = {} end
  for _, plugin in ipairs(list) do
    if type(plugin) == "string" then table.insert(tbl,{ src = plugin })
    elseif type(plugin) == "table" then
      ---@diagnostic disable-next-line: undefined-field
      if plugin.src then table.insert(tbl, plugin)
      else for _, p in ipairs(plugin) do
        tbl = vim.pack.packit_flatten({ p }, tbl)
      end end
    end
  end
  return tbl
end




---PACKIT
---@param list PackitList
function vim.pack.packit(list)
  local int_list = vim.pack.packit_flatten(list)
  -- local int_list = list
  vim.pack.add(int_list)
  for _, plugin in ipairs(int_list) do
    if type(plugin) == "table" and plugin.config then
      plugin.config()
    end
  end
end

---Runs `cmd` in silent mode
---@param cmd string vim command mode command
---@return string, string output message and possible error description string
function vim.utils.run_cmd_capture(cmd)
  vim.v.errmsg = ""
  vim.cmd("redir => g:__cmd_output")
  vim.cmd("silent " .. cmd)
  vim.cmd("redir END")

  local out = vim.g.__cmd_output or ""
  vim.g.__cmd_output = nil

  return out, vim.v.errmsg
end

---Returns true if the current buffer is the intro buffer
---@return boolean
function vim.utils.is_intro_buffer()
  local name = vim.api.nvim_buf_get_name(0)
  local buftype = vim.bo.buftype
  local line_count = vim.api.nvim_buf_line_count(0)
  local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]
  return name == "" and buftype == "" and line_count <= 1 and (first_line == "" or first_line == nil)
end

---Opens intro buffer
function vim.utils.intro()
    vim.utils.run_cmd_capture("intro");
end
