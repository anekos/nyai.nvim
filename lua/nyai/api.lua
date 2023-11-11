local curl = require('plenary.curl')

local M = {}

function M.chat_completions(parameters, callback)
  curl.request {
    method = 'POST',
    url = 'https://api.openai.com/v1/chat/completions',
    headers = {
      content_type = 'application/json',
      ['Authorization'] = 'Bearer ' .. vim.env.OPENAI_API_KEY,
    },
    body = vim.fn.json_encode(parameters),
    timeout = 60 * 1000,
    callback = function (resp)
      callback(resp.body)
    end
  }
end

return M
