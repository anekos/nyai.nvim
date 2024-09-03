local state = require('nyai.state')

local M = {}

local state_file = vim.fn.stdpath('data') .. '/nyai.state.json'

function M.save_state()
  local file = io.open(state_file, 'w')
  if file then
    local json_data = vim.fn.json_encode(state.values)
    file:write(json_data)
    file:close()
  end
end

function M.load_state()
  local file = io.open(state_file, 'r')
  if not file then
    return
  end

  local content = file:read('*a')
  local loaded_state = vim.fn.json_decode(content)
  file:close()

  state.values = loaded_state
end

return M
