local api = require('nyai.api')
local config = require('nyai.config')

local M = {}

local function from_context(ctx)
  local request = { model = config.model, parameters = {} }

  for key, value in pairs(ctx.parameters) do
    if key == 'model' then
      local got = config.get_model(value)
      if got == nil then
        error('Model not found: ' .. value)
      end
      request.model = got
    else
      request.parameters[key] = value
    end
  end

  request.parameters.messages = ctx.messages

  return request
end

function M.run(context)
  local current_buffer = vim.api.nvim_get_current_buf()
  local current_win = vim.api.nvim_get_current_win()
  local request = from_context(context)

  local on_resp = function(body)
    if '... WAITING ...' == vim.fn.getline(context.insert_to + 1) then
      vim.api.nvim_buf_set_lines(current_buffer, context.insert_to, context.insert_to + 1, false, {})
    end

    local lines = { '# assistant', '' }

    if context.at_last then
      table.insert(lines, 1, '')
    end

    for _, line in ipairs(vim.split(body, '\n')) do -- FIXME ?
      table.insert(lines, line)
    end

    table.insert(lines, '')
    table.insert(lines, '# user')
    table.insert(lines, '')
    table.insert(lines, '')

    if not context.at_last then
      table.insert(lines, '')
    end

    vim.api.nvim_buf_set_lines(current_buffer, context.insert_to, context.insert_to, false, lines)

    if context.at_last then
      local num_lines = vim.api.nvim_buf_line_count(current_buffer)
      vim.api.nvim_win_set_cursor(current_win, { num_lines, 0 })
    else
      vim.api.nvim_win_set_cursor(current_win, { #lines + context.insert_to - 1, 0 })
    end

    vim.cmd.startinsert()
  end

  vim.api.nvim_buf_set_lines(current_buffer, context.insert_to, context.insert_to, false, { '... WAITING ...' })
  vim.cmd.stopinsert()

  api.chat_completions(request, on_resp)
end

return M
