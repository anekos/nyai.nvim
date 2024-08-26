local curl = require('plenary.curl')
local config = require('nyai.config')

local M = {}

function M.chat_completions(parameters, callback)
  curl.request {
    method = 'POST',
    url = config.model.api_endpoint,
    headers = {
      content_type = 'application/json',
      ['Authorization'] = 'Bearer ' .. config.model.api_key,
    },
    body = vim.fn.json_encode(parameters),
    timeout = 60 * 1000,
    callback = function(resp)
      print(vim.inspect(resp.body))
      callback(resp.body)
    end,
  }
end

return M
