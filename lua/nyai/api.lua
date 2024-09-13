local curl = require('plenary.curl')

local util = require('nyai.util')

local M = {}

local function generate_headers(headers)
  local result = {}
  for key, value in pairs(headers) do
    result[key] = util.value_or_function(value)
  end
  return result
end

function M.chat_completions(request, callbacks)
  -- request = { parameters, model }

  local params = vim.tbl_extend('force', request.model.default_parameters or {}, vim.deepcopy(request.parameters))

  local headers = generate_headers(vim.tbl_extend('force', {
    content_type = 'application/json',
  }, request.model.headers or {}))

  params.stream = true

  if request.model.id then
    params.model = request.model.id
  end

  curl.request {
    method = 'POST',
    url = request.model.api_endpoint,
    headers = headers,
    body = vim.fn.json_encode(params),
    timeout = 60 * 1000,
    stream = request.model.stream(callbacks),
    callback = function(resp)
      if resp.status ~= 200 then
        error('API Error: ' .. resp.body)
      end
    end,
  }
end

return M
