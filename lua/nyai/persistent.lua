local config = require('nyai.config')

local M = {}

local state_file = vim.fn.stdpath('data') .. '/nyai.state.json'

function M.save_state()
  local state = {
    model_name = config.model.name,
  }

  local file = io.open(state_file, 'w')
  if file then
    local json_data = vim.fn.json_encode(state)
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
  local state = vim.fn.json_decode(content)
  file:close()

  local ok, loaded_model = pcall(config.get_model, state.model_name)
  if ok then
    config.model = loaded_model
  end
end

return M
