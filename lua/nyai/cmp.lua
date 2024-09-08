local kind = require('cmp.types.lsp').CompletionItemKind

local buffer = require('nyai.buffer')
local state = require('nyai.state')

local M = {}

local last_state = nil
local buffer_context = nil

local model_names = state.model_names()

M.new = function()
  local self = setmetatable({}, { __index = M })
  return self
end

M.is_available = function()
  return true
end

function M.get_keyword_pattern()
  return [[\K\+]]
end

function M.get_trigger_characters()
  return { '@', '=', ' ' }
end

local function get_current_model()
  if buffer_context and buffer_context.parameters.model then
    return state.get_model(buffer_context.parameters.model, true)
  end

  return state.default_model()
end

function M:complete(params, callback)
  local ctx = params.context

  local current = { ctx.bufnr, ctx.cursor.line }
  if buffer_context == nil or not vim.deep_equal(current, last_state) then
    buffer_context = buffer.get_context()
  end

  local model = get_current_model()

  if ctx.cursor_before_line:match('^@model%s*=%s*') then
    callback {
      items = vim.tbl_map(function(name)
        return {
          label = name,
          kind = kind.Value,
        }
      end, model_names),
    }
    return
  end

  if ctx.cursor_before_line:match('^@[%s%w_]+=') then
    callback {}
    return
  end

  if ctx.cursor_before_line:match('^@') then
    local items = { { label = '@model', kind = kind.Property } }

    if model and model.parameters then
      for key, value in pairs(model.parameters) do
        table.insert(items, {
          label = vim.fn.printf('@%s (%s)', key, value),
          kind = kind.Property,
          insertText = '@' .. key,
        })
      end
    end

    callback { items = items }
    return
  end

  callback {}
end

return M
