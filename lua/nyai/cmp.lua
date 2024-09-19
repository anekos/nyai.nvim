local kind = require('cmp.types.lsp').CompletionItemKind

local buffer = require('nyai.buffer')
local state = require('nyai.state')

local M = {}

local function debug(...)
  local args = { ... }
  vim.schedule(function()
    vim.fn.writefile({ vim.fn.json_encode(args) }, '/tmp/xmosh/nvim-debug.log', 'a')
  end)
end

local last_state = nil
local buffer_context = nil

local cached_model_names = nil

local function model_names()
  if cached_model_names == nil then
    cached_model_names = state.model_names()
  end
  return cached_model_names
end

local function prefixed(prefix, ctx, callback)
  local line = ctx.cursor_before_line
  local cursor_col = ctx.cursor.col
  local equal_sign_pos = line:find('=')

  return function(candidates)
    local filtered = {}
    for _, candidate in ipairs(candidates) do
      local value = candidate.insertText or candidate.label
      if vim.startswith(value, prefix) then
        table.insert(
          filtered,
          vim.tbl_extend('force', candidate, {
            textEdit = {
              newText = value,
              range = {
                start = {
                  line = ctx.cursor.line,
                  character = equal_sign_pos,
                },
                ['end'] = {
                  line = ctx.cursor.line,
                  character = cursor_col - 1,
                },
              },
            },
          })
        )
      end
    end
    return callback(filtered)
  end
end

M.new = function()
  local self = setmetatable({}, { __index = M })
  return self
end

M.is_available = function()
  return true
end

function M.get_keyword_pattern()
  return [[\k\+]]
end

function M.get_trigger_characters()
  return { '@', '=', ' ' }
end

local function complete_model_names(callback)
  callback(vim.tbl_map(function(name)
    return {
      label = name,
      kind = kind.Value,
    }
  end, model_names()))
end

local function complete_model_parameters(callback, model_parameters)
  local items = { { label = '@model', kind = kind.Property } }

  for key, value in pairs(model_parameters) do
    table.insert(items, {
      ---@diagnostic disable-next-line: redundant-parameter
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

  local key, value = ctx.cursor_before_line:match('^@([%w_]+)%s*=%s*(.*)')

  if key == 'model' then
    return complete_model_names(prefixed(value, ctx, callback))
  end

  local model = buffer_context and buffer_context.model

  if key then
    if model then
      return complete_model_parameter_values(prefixed(value, ctx, callback), model.parameters[key])
    end

    callback {}
    return
  end

  key = ctx.cursor_before_line:match('^(@[%w_]*)')

  if key ~= nil then
    if model and model.parameters then
      return complete_model_parameters(callback, model.parameters)
    end
  end

  callback {}
end

return M
