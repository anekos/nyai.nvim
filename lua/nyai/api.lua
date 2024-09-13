local curl = require('plenary.curl')

local M = {}

function M.chat_completions(request, callbacks)
  -- request = { url, headers, body, query, response }

  local headers = vim.tbl_extend('force', { ['Content-Type'] = 'application/json' }, request.headers or {})
  local response = request.response(callbacks)

  curl.request {
    method = 'POST',
    url = request.url,
    query = request.query or {},
    headers = headers,
    body = vim.json.encode(request.body),
    timeout = 60 * 1000,
    stream = response.on_stream,
    callback = function(resp)
      if resp.status ~= 200 then
        error('API Error: ' .. resp.body)
      end
      response.on_complete()
    end,
  }
end

return M
