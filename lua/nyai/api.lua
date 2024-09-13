local curl = require('plenary.curl')

local M = {}

function M.chat_completions(request, callbacks)
  -- request = { url, headers, body, query, stream }

  local headers = vim.tbl_extend('force', { ['Content-Type'] = 'application/json' }, request.headers or {})

  vim.print(request)

  curl.request {
    method = 'POST',
    url = request.url,
    query = request.query or {},
    headers = headers,
    body = vim.json.encode(request.body),
    timeout = 60 * 1000,
    stream = request.stream(callbacks),
    callback = function(resp)
      if resp.status ~= 200 then
        error('API Error: ' .. resp.body)
      end
    end,
  }
end

return M
