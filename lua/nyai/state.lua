local config = require('nyai.config')
local predefined = require('nyai.predefined')
local util = require('nyai.util')

local M = { values = {} }

function M.all_models()
  local models = {}
  for _, model in ipairs(util.value_or_function(config.user_models)) do
    table.insert(models, model)
  end
  for _, model in ipairs(predefined.models) do
    table.insert(models, model)
  end
  return models
end

function M.cmp_model()
  return util.value_or_function(config.cmp_model)
end

function M.get_model(name, nil_if_not_found)
  for _, model in ipairs(M.all_models()) do
    if model.name == name then
      return model
    end
  end

  if nil_if_not_found then
    return nil
  end

  error('Model not found: ' .. name)
end

function M.model_names()
  return vim.tbl_map(function(model)
    return model.name
  end, M.all_models())
end

function M.model_ids()
  return vim.tbl_map(function(model)
    return model.id
  end, M.all_models())
end

function M.set_model(name)
  local model = M.get_model(name)
  if model == nil then
    error('Model not found: ' .. name)
  end
  M.values.model_name = name
end

function M.default_model()
  return M.get_model(M.values.model_name, true) or M.all_models()[1]
end

return M
