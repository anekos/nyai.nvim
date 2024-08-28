local action = require('nyai.action')
local buffer = require('nyai.buffer')
local config = require('nyai.config')

local M = {}

M.last_buffer = nil

function M.chat(a)
  if #a.args == 0 then
    vim.cmd.edit(buffer.new_filename())
    local buf = vim.api.nvim_get_current_buf()
    buffer.initialize(buf, buffer.new_filename(), false)
    buffer.ready_to_edit()
  else
    action.run_with_template(a.args, a.bang)
  end
end

function M.float(opts)
  local new_buffer = opts.bang or M.last_buffer == nil

  local fname = buffer.new_filename()

  local buf
  if new_buffer then
    buf = vim.api.nvim_create_buf(true, false)
    M.last_buffer = buf
  else
    buf = M.last_buffer
  end

  local win = vim.api.nvim_open_win(buf, true, config.float_options())
  vim.api.nvim_win_set_option(win, 'winblend', 20)

  if new_buffer then
    buffer.initialize(buf, fname, true)
    buffer.ready_to_edit()
    return
  end

  vim.cmd.startinsert()
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
