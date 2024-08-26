local action = require('nyai.action')
local config = require('nyai.config')

local M = {}

function M.chat(a)
  if #a.args == 0 then
    local fname = vim.fn.strftime('~/nyai/%Y%m%d-%H%M.nyai')
    vim.cmd.edit(fname)
  else
    action.run_with_template(a.args, a.bang)
  end
end

function M.model(a)
  if vim.trim(a.args) ~= '' then
    config.model = config.get_model(a.args)
    return
  end
  vim.ui.select(config.all_models(), {
    prompt = 'Select model',
    format_item = function(model)
      return model.name
    end,
  }, function(model)
    config.model = model
  end)
end
return M
