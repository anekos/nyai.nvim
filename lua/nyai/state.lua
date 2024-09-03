local predefined = require('nyai.predefined')
local config = require('nyai.config')

local M = {}

function M.all_models()
  local models = {}
  for _, model in ipairs(config.user_models) do
    table.insert(models, model)
  end
  for _, model in ipairs(predefined.models) do
    table.insert(models, model)
  end
  return models
end

function M.get_model(name)
  for _, model in ipairs(M.all_models()) do
    if model.name == name then
      return model
    end
  end

  error('Model not found: ' .. name)
end

function M.model_names()
  return vim.tbl_map(function(model)
    return model.name
  end, M.all_models())
end

function M.set_model(name)
  local model = M.get_model(name)
  if model == nil then
    error('Model not found: ' .. name)
  end
  M.model = model
end

M.model = M.all_models()[1]

return M
