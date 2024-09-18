local kind = require('cmp.types.lsp').CompletionItemKind

local buffer = require('nyai.buffer')
local state = require('nyai.state')

local M = {}

local last_state = nil
local buffer_context = nil

local cached_model_names = nil

local function model_names()
  if cached_model_names == nil then
    cached_model_names = state.model_names()
  end
  return cached_model_names
end

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

local function complte_model_names(callback)
  callback {
    items = vim.tbl_map(function(name)
      return {
        label = name,
        kind = kind.Value,
      }
    end, model_names()),
  }
end

local function complete_model_parameters(callback, model_parameters)
  local items = { { label = '@model', kind = kind.Property } }

  for key, value in pairs(model_parameters) do
    table.insert(items, {
      label = vim.fn.printf('@%s (%s)', key, value.description),
      kind = kind.Property,
      insertText = '@' .. key,
    })
  end

  callback(items)
end

local function complete_model_parameter_values(callback, model_parameter)
  if not model_parameter then
    callback {}
    return
  end

  callback(vim.tbl_map(function(it)
    return {
      label = it,
      kind = kind.Value,
    }
  end, model_parameter.completions))
end

function M:complete(params, callback)
  local ctx = params.context

  local current = { ctx.bufnr, ctx.cursor.line }
  if buffer_context == nil or not vim.deep_equal(current, last_state) then
    buffer_context = buffer.get_context(false)
  end

  local model = buffer_context and buffer_context.model

  if ctx.cursor_before_line:match('^@model%s*=%s*') then
    return complte_model_names(callback)
  end

  local parameter_name = ctx.cursor_before_line:match('^@([%w_]+)%s*=')

  if parameter_name then
    if model then
      return complete_model_parameter_values(callback, model.parameters[parameter_name])
    end

    callback {}
    return
  end

  if ctx.cursor_before_line:match('^@') then
    if model and model.parameters then
      return complete_model_parameters(callback, model.parameters)
    end
  end

  callback {}
end

return M
