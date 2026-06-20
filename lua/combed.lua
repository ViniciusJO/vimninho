-- local M = {}
--
-- local ns = vim.api.nvim_create_namespace("comment_commands")
-- local shell_path = os.getenv("SHELL") or "bash"
-- local shell = shell_path:sub((vim.utils.rfind(shell_path, "/") or 0) + 1)
--
-- -- print("++++++++++++++++++++++++"..shell)
--
-- --------------------------------------------------------------------------------
-- -- Mock validators
-- --------------------------------------------------------------------------------
--
-- ---@param cmd string
-- ---@return boolean
-- local function is_valid_vim_command(cmd)
--     -- TODO: Implement
--     return true
-- end
--
-- ---@param cmd string
-- ---@return boolean
-- local function is_valid_shell_command(cmd)
--     -- TODO: Implement
--     return true
-- end
--
-- --------------------------------------------------------------------------------
-- -- Command extraction
-- --------------------------------------------------------------------------------
--
-- ---@param comment string
-- ---@return string?, string?, integer?
-- local function extract_command(comment)
--     --------------------------------------------------------------------------
--     -- Strip common comment markers.
--     -- Extend this as desired.
--     --------------------------------------------------------------------------
--
--     local content = comment
--
--     content = content:gsub("^%s*%-%-%s*", "") -- Lua
--     content = content:gsub("^%s*#%s*", "")    -- Shell/Python
--     content = content:gsub("^%s*//%s*", "")   -- C/C++
--     content = content:gsub("^%s*;%s*", "")    -- Lisp
--
--     --------------------------------------------------------------------------
--     -- Shell command
--     --------------------------------------------------------------------------
--
--     if content:match("^:!") then
--         return shell, content:sub(3), comment:find(content)
--     end
--
--     if content:match("^!") then
--         return shell, content:sub(2), comment:find(content)
--     end
--
--     --------------------------------------------------------------------------
--     -- Vim command
--     --------------------------------------------------------------------------
--
--     if content:match("^:") then
--         return "vim", content, comment:find(content)
--     end
--
--     return nil
-- end
--
--
--
-- --------------------------------------------------------------------------------
-- -- Copy TS captures from injected parser to original buffer
-- --------------------------------------------------------------------------------
--
-- ---@param bufnr integer
-- ---@param row integer
-- ---@param col_offset integer
-- ---@param text string
-- ---@param lang string
-- local function highlight_embedded(bufnr, row, col_offset, text, lang)
--     local parser_ok, parser =
--         pcall(vim.treesitter.get_string_parser, text, lang)
--     if not parser_ok then return end
--
--     local tree = parser:parse()[1]
--     if not tree then return end
--
--     local query = vim.treesitter.query.get(lang, "highlights")
--     if not query then return end
--
--     local root = tree:root()
--
--     -- :lua print(2+2)
--
--     for id, node in query:iter_captures(root, text) do
--         local capture = query.captures[id]
--
--         local sr, sc, er, ec = node:range()
--
--         ----------------------------------------------------------------------
--         -- Ignore multiline captures for now.
--         ----------------------------------------------------------------------
--
--         if sr == er then
--             local hl = "@" .. capture
--
--             pcall(vim.api.nvim_buf_set_extmark,
--                 bufnr,
--                 ns,
--                 row,
--                 col_offset + sc,
--                 {
--                     end_col = col_offset + ec,
--                     hl_group = hl,
--                     priority = 200,
--                 }
--             )
--         end
--     end
-- end
--
-- --------------------------------------------------------------------------------
-- -- Process a single comment node
-- --------------------------------------------------------------------------------
--
-- ---@param bufnr integer
-- ---@param node TSNode
-- local function process_comment(bufnr, node)
--     local comment = vim.treesitter.get_node_text(node, bufnr)
--     if not comment or comment == "" then return; end
--
--     local lang, command, command_col = extract_command(comment)
--     if not lang or not command then return; end
--
--     --------------------------------------------------------------------------
--     -- Validation
--     --------------------------------------------------------------------------
--
--     if not (
--       (lang == "vim" and is_valid_vim_command(command)) or
--       (lang == shell and is_valid_shell_command(command))
--     ) then return end
--
--     --------------------------------------------------------------------------
--     -- Highlight
--     --------------------------------------------------------------------------
--
--     local row, col = node:start()
--     highlight_embedded(bufnr, row, col + command_col - 1, command, lang)
-- end
--
-- --------------------------------------------------------------------------------
-- -- Scan entire syntax tree
-- --------------------------------------------------------------------------------
--
-- ---@param bufnr integer
-- local function scan_buffer(bufnr)
--     vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
--
--     local parser = vim.treesitter.get_parser(bufnr)
--     if not parser then return; end
--
--     local lang = parser:lang()
--
--     local query_ok, query = pcall(vim.treesitter.query.parse, lang, [[
--       (comment) @comment
--     ]])
--     if not query_ok then return; end
--
--     local p = parser:parse();
--     if p == nil then return; end
--
--     for _, tree in ipairs(p) do
--         local root = tree:root()
--         for _, node in query:iter_captures(root, bufnr) do
--             process_comment(bufnr, node)
--         end
--     end
-- end
--
-- --------------------------------------------------------------------------------
-- -- Public API
-- --------------------------------------------------------------------------------
--
-- function M.refresh(bufnr)
--     bufnr = bufnr or vim.api.nvim_get_current_buf()
--
--     pcall(scan_buffer, bufnr)
-- end
--
-- function M.enable()
--     local group = vim.api.nvim_create_augroup("CommentCommandHighlight", { clear = true })
--
--     vim.api.nvim_create_autocmd({ "BufEnter", "TextChanged", "TextChangedI", "InsertLeave" }, {
--         group = group,
--         callback = function(args)
--             M.refresh(args.buf)
--         end,
--     })
--
--     vim.api.nvim_create_autocmd("BufWinEnter", {
--         group = group,
--         callback = function(args)
--             vim.schedule(function()
--                 M.refresh(args.buf)
--             end)
--         end,
--     })
-- end


-- TODO:
--  - execution aware of entire comment scope, not only the line
--  - execution aware visual selection
--  - execution aware visual selection in lua (no comment or marker needed)


-- local function append_multiline(lines, position)
--   local buf = vim.api.nvim_get_current_buf()
--   vim.api.nvim_buf_set_lines(buf, position, position, false, lines)
-- end
--
-- local function append_multiline_indent(lines, position, indent)
--   local padding = ""
--   for _ = 1, indent, 1 do padding = padding .. " " end
--
--   local indented_lines = {}
--   for _, line in ipairs(lines) do
--     table.insert(indented_lines, padding .. line)
--   end
--
--   append_multiline(indented_lines, position)
-- end
--
-- local function remove_line_from_buffer(line_number)
--   local buf = vim.api.nvim_get_current_buf()
--   vim.api.nvim_buf_set_lines(buf, line_number - 1, line_number, false, {})
-- end

-- local function count_leading_spaces(str)
--   local count = 0
--   for i = 1, #str do
--     if str:sub(i, i) == " " then
--       count = count + 1
--     else
--       break
--     end
--   end
--   return count
-- end

---@class Combed
---@field executeCommandInBuffer fun(replace: boolean): fun()
local M = {}

-- TODO:
--    - Highlight with treesitter the commands inside comments
--    - Support multiline cmds
--

--- Create a function that evaluates the ***command line*** under the cursor
--- The command can be in a comment or in plain text, but need to start with `:` for vim mode commands or with `!` for shell (`bash`) command. NOTE: `:!` works as shell command
---
--- Example in lua:
--- ``` lua
--- --- !ls -la
--- ```
---
--- ``` lua
--- --- :echo "CMD TEST"
--- ```
---
--- ``` lua
--- :messages
--- ```
---
--- ``` bash
--- :!cat file.txt
--- ```
---@param replace boolean wheter to replace the command line (true) or append afther it (false)
---@return fun()
function M.executeCommandInBuffer(replace)
  return function()
    local is_comment = vim.treesitter.get_node():type():find("comment") ~= nil

    local linen = vim.fn.line('.')
    local line_content = vim.fn.getline(linen)

    if is_comment then
      line_content = line_content:sub(line_content:find(":") or line_content:find("!") or 0)
    end

    local command = line_content:gsub("^%s*", "")
    if nil == command:find("^:") and nil == command:find("^!") then
      vim.notify('\"' .. command .. '\" is not a valid command', vim.log.levels.ERROR)
      return
    end
    local result = vim.api.nvim_exec2(command, { output = true }).output
        :gsub("\0", "")
        :gsub(string.char(10), "\r")
        :gsub("%z", "")
        :gsub("^:*" .. command:gsub("^:", ""), "")
    local lines = vim.split(result, "\r")

    if lines[1] == command:gsub("^!", ":!") then table.remove(lines, 1) end
    while '' == lines[1] do table.remove(lines, 1) end
    if lines[#lines] == "" then table.remove(lines, #lines) end

    vim.utils.append_multiline_indent(lines, linen, vim.utils.count_leading_spaces(line_content))
    if replace then
      vim.utils.remove_line_from_buffer(linen)
    end
  end
end


-- Examples

-- :echo "ola"
-- :!ls -la
-- print("p") -- !cat ~/.background


--[[:echo "ola"]]
--[[:!ls -la]]
--[[!cat ~/.background]]

--[[
-- :echo "ola"
]]
--[[
:!echo "An error occurred!" >&2
]]
--[[
--:!ls -la
]]
--[[
!cat ~/.background
]]





return M



--[[ TS Query
((comment_content) @_command (#match? @_command "^[ \n\r-]*:[^!]")) @_cmd
((comment_content) @_bash_command (#match? @_bash_command "^[ \n\r-]*(:?)!")) @_bash_cmd
]]
