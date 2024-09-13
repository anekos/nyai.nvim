local command = require('nyai.command')
local config = require('nyai.config')
local event = require('nyai.event')
local persistent = require('nyai.persistent')
local state = require('nyai.state')

local M = {}

function M.setup(opts)
  local function apply(name)
    if opts[name] ~= nil then
      config[name] = opts[name]
    end
  end

  apply('model')
  apply('user_models')
  apply('insert_default_model')
  apply('api_end_point')
  apply('api_key')
  apply('float_options')

  persistent.load_state()

  local group = vim.api.nvim_create_augroup('Nyai', { clear = true })

  vim.api.nvim_create_autocmd({ 'FileType' }, {
    group = group,
    pattern = 'nyai',
    callback = event.on_filetype,
  })

  vim.api.nvim_create_autocmd({ 'VimLeavePre' }, {
    group = group,
    pattern = '*',
    callback = event.on_vim_leave_pre,
  })

  vim.api.nvim_create_user_command('NyaiChat', command.chat, {
    nargs = 0,
    range = true,
    bang = true,
    bar = true,
  })

  vim.api.nvim_create_user_command('NyaiFloat', command.float, {
    nargs = '*',
    bang = true,
    bar = true,
  })

  vim.api.nvim_create_user_command('NyaiModel', command.model, {
    nargs = '*',
    complete = state.model_names,
    bar = true,
  })
end

return M
