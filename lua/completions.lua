---@alias Completion.Source.get fun(opts: { ctx: table }?): 

---@class Completion
---@field completion { get: Completion.Source.get }
local M = { completion = {} }

--- @class Completion.Source
--- @field get fun(opts: { ctx: table }?)

vim.lsp.completion.sources = {}

M.orig_lsp_completion_get = vim.lsp.completion.get

vim.
vim.keymap.set('i', '<c-space>', function()
  local s = vim.lsp.completion.get()
  vim.print(s)
end)

--- Registers a completion source
---
---@param sources Completion.Source | table<Completion.Source>
function vim.lsp.completion.register_sources(sources)
  if not sources then return end
  if sources.get then
    return table.insert(vim.lsp.completion.sources, sources)
  end

  for _, source in ipairs(sources) do
    table.insert(vim.lsp.completion.sources, source)
  end
end

---@type Completion.Source.get
function M.completion.get(...)
  local items = M.orig_lsp_completion_get(...)
  for _, source in ipairs(vim.lsp.completion.sources) do
    table.insert(items, source.get())
  end
  return items
end

function M.setup(opts)
  opts = opts or {}
  vim.lsp.register_sources(opts.sources)
  vim.lsp.completion.get = M.completion.get
end

function M.disable()
  vim.lsp.completion.get = M.orig_lsp_completion_get
end

return M
