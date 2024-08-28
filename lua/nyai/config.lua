local predefined = require('nyai.predefined')

local M = {
  user_models = {},
  directory = vim.fn.expand('~/nyai'),
  float_options = function()
    local columns = vim.api.nvim_get_option('columns')
    local lines = vim.api.nvim_get_option('lines')

    local width = math.max(columns / 3, 70)
    local height = math.max(lines / 3, 30)

    return {
      style = 'minimal',
      relative = 'editor',
      width = width,
      height = height,
      row = math.floor(lines / 2 - height / 2),
      col = math.floor(columns / 2 - width / 2),
      border = 'single',
    }
  end,
}

function M.all_models()
  local models = {}
  for _, model in ipairs(M.user_models) do
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
  local names = {}
  for _, model in ipairs(M.all_models()) do
    table.insert(names, model.name)
  end
  return names
end

M.model = M.get_model('OpenAI - GPT 4o')

return M
