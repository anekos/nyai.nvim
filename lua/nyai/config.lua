local M = {
  user_models = {},
  directory = vim.fn.expand('~/nyai'),
  insert_default_model = false,
  float_options = function()
    local columns = vim.api.nvim_get_option_value('columns', {})
    local lines = vim.api.nvim_get_option_value('lines', {})

    local width = math.floor(math.max(columns / 3, 70))
    local height = math.floor(math.max(lines / 3, 30))

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

return M
