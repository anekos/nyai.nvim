local config = require('nyai.config')
local kind = require('cmp.types.lsp').CompletionItemKind

local M = {}

local model_names = config.model_names()

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

function M:complete(params, callback)
  local ctx = params.context

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

  if ctx.cursor_before_line:match('^@') then
    callback {
      items = {
        { label = '@model', kind = kind.Property },
      },
    }
    return
  end

  callback {}
end

return M
