local predefined = require('nyai.predefined')
local config = require('nyai.config')

local M = { values = {} }

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

function M.get_model(name_or_id, nil_if_not_found)
  for _, model in ipairs(M.all_models()) do
    if model.id == name_or_id then
      return model
    end
    if model.name == name_or_id then
      return model
    end
  end

  if nil_if_not_found then
    return nil
  end

  error('Model not found: ' .. name_or_id)
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

function M.set_model(name_or_id)
  local model = M.get_model(name_or_id)
  if model == nil then
    error('Model not found: ' .. name_or_id)
  end
  M.model = model
end

function M.default_model()
  return M.get_model(M.values.model_id)
end

M.model_id = M.all_models()[1].id

return M
