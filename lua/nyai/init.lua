local M = {}

local action = require('nyai.action')
local event = require('nyai.event')
local config = require('nyai.config')

function M.setup(opts)
  local function apply(name)
    if opts[name] ~= nil then
      config[name] = opts[name]
    end
  end

  apply('model')
  apply('api_end_point')
  apply('api_key')

  local group = vim.api.nvim_create_augroup('Nyai', { clear = true })

  vim.api.nvim_create_autocmd({ 'FileType' }, {
    group = group,
    pattern = 'nyai',
    callback = event.on_cr,
  })

  vim.api.nvim_create_user_command('NyaiChat', function(a)
    -- print(vim.inspect(a))
    -- print(vim.inspect(a.bang))
    if #a.args == 0 then
      local fname = vim.fn.strftime('~/nyai/%Y%m%d-%H%M.nyai')
      vim.cmd.edit(fname)
    else
      action.run_with_template(a.args, a.bang)
    end
  end, { nargs = '*', complete = require('nyai.completion').complete_templates, range = true, bang = true })

  vim.api.nvim_create_user_command('NyaiModel', function(a)
    config.model = config.get_model(a.args)
  end, {
    nargs = '*',
    complete = config.model_names,
    range = true,
    bang = true,
  })
end

return M
