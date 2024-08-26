local curl = require('plenary.curl')
local config = require('nyai.config')

local M = {}

function M.chat_completions(parameters, callback)
  curl.request {
    method = 'POST',
    url = config.api_end_point,
    headers = {
      content_type = 'application/json',
      ['Authorization'] = 'Bearer ' .. config.api_key,
    },
    body = vim.fn.json_encode(parameters),
    timeout = 60 * 1000,
    callback = function(resp)
      callback(resp.body)
    end,
  }
end

return M
