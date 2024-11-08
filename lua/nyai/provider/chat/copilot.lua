local curl = require('plenary.curl')

local authorized = nil

local M = {}

M.common_headers = {
  ['editor-version'] = 'Neovim/' .. vim.version().major .. '.' .. vim.version().minor .. '.' .. vim.version().patch,
  ['editor-plugin-version'] = 'nyai.nvim/0.1.0',
  ['user-agent'] = 'nyai.nvim/0.1.0',
  ['copilot-integration-id'] = 'vscode-chat',
}

function M.authorize()
  local token = vim.env.GITHUB_COPILOT_TOKEN or vim.env.GITHUB_TOKEN

  if authorized and authorized.expires_at and authorized.expires_at <= math.floor(os.time()) then
    return authorized.token
  end

  local url = 'https://api.github.com/copilot_internal/v2/token'
  local headers = {
    ['authorization'] = 'token ' .. token,
    ['accept'] = 'application/json',
  }
  for key, value in pairs(M.common_headers) do
    headers[key] = value
  end

  local resp = curl.get(url, {
    headers = headers,
  })

  if resp.status ~= 200 then
    error('Failed to authorize: ' .. resp.body)
  end

  authorized = vim.fn.json_decode(resp.body)

  return authorized.token
end

return M
