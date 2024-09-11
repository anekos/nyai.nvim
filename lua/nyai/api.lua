local curl = require('plenary.curl')

local util = require('nyai.util')

local M = {}

function M.chat_completions(request, callback)
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

  params.stream = false
  if request.model.id then
    params.model = request.model.id
  end

  curl.request {
    method = 'POST',
    url = request.model.api_endpoint,
    headers = headers,
    body = vim.fn.json_encode(params),
    timeout = 60 * 1000,
    callback = function(resp)
      if resp.status ~= 200 then
        error('Failed to request chat completions: ' .. resp.body)
      end

      vim.schedule(function()
        local body = vim.fn.json_decode(resp.body)

        -- Ollama
        -- https://github.com/ollama/ollama/blob/main/docs/api.md
        if body.message and body.message.content then
          callback(body.message.content)
          return
        end

        -- Open AI
        callback(body.choices[1].message.content)
      end)
    end,
  }
end

return M
