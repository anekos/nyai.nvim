local state = require('nyai.state')

local M = {}

local state_file = vim.fn.stdpath('data') .. '/nyai.state.json'

function M.save_state()
  local state_to_state = {}

  for key, value in pairs(state) do
    if type(value) ~= 'function' then
      state_to_state[key] = value
    end
  end

  local file = io.open(state_file, 'w')
  if file then
    local json_data = vim.fn.json_encode(state_to_state)
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

  for key, value in pairs(loaded_state) do
    state[key] = value
  end
end

return M
