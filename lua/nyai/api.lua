local curl = require('plenary.curl')

local M = {}

function M.chat_completions(request, callback)
  -- request = { parameters, model }

  vim.print(request)
  local params = vim.deepcopy(request.parameters)

  local headers = {
    content_type = 'application/json',
  }

  if request.model.api_key then
    headers['Authorization'] = 'Bearer ' .. request.model.api_key
  end

  params.stream = false
  params.model = request.model.id

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
