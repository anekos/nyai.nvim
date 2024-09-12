local curl = require('plenary.curl')

local util = require('nyai.util')

local M = {}

function M.chat_completions(request, callbacks)
  -- request = { parameters, model }

  local params = vim.deepcopy(request.parameters)

  local headers = {
    content_type = 'application/json',
  }

  if request.model.api_key then
    local api_key = request.model.api_key
    if type(api_key) == 'function' then
      api_key = api_key()
    end
    headers['Authorization'] = 'Bearer ' .. api_key
  end

  local model_headers = util.value_or_function(request.model.headers)
  if model_headers then
    headers = vim.tbl_extend('force', headers, model_headers)
  end

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
