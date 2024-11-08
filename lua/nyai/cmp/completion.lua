local state = require('nyai.state')
local api = require('nyai.api')

local M = {}

M.candidates = {}

function M.new()
  return setmetatable({}, { __index = M })
end

function M.get_keyword_pattern()
  return [[\k\+]]
end

function M.is_available()
  return state.cmp_model() ~= nil
end

function M:complete(params, callback)
  local ctx = params.context

  local prev = ctx.prev_context
  local ln = prev.cursor.line

  local prefix = vim.fn.join(vim.api.nvim_buf_get_lines(ctx.bufnr, 1, ln, true), '\n')
    .. '\n'
    .. prev.cursor_before_line
  local suffix = '\n' .. vim.fn.join(vim.api.nvim_buf_get_lines(ctx.bufnr, ln + 1, -1, true), '\n')

  local cmp_model = state.cmp_model()

  if cmp_model == nil then
    error('WTF')
  end

  local p = cmp_model.request(prefix, suffix)

  local request = {
    url = p.url,
    headers = p.headers,
    body = p.body,
    response = function()
      return {
        on_response = function(data)
          callback {
            {
              label = 'nyai',
              insertText = data.response,
            },
          }
        end,
        on_complete = function() end,
      }
    end,
  }

  api.call(request, nil)
end

return M
