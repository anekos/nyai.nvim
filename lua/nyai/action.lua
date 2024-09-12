local api = require('nyai.api')
local text = require('nyai.text')
local util = require('nyai.util')

local M = {}

local function from_context(ctx)
  local request = { model = ctx.model, parameters = ctx.parameters }
  request.parameters.messages = ctx.messages
  return request
end

function M.run(context)
  local current_win = vim.api.nvim_get_current_win()
  local current_buffer = vim.api.nvim_get_current_buf()
  local request = from_context(context)
  local renderer = require('nyai.buffer.renderer').new {
    win = current_win,
    line = context.insert_to + 1,
    col = 1,
  }

  local callbacks = {
    on_start = function()
      if
        text.Waiting == vim.api.nvim_buf_get_lines(current_buffer, context.insert_to, context.insert_to + 1, false)[1]
      then
        vim.api.nvim_buf_set_lines(current_buffer, context.insert_to, context.insert_to + 1, false, {})
      end

      renderer:render('\n' .. text.Header.Assistant .. '\n\n')
    end,
    on_text = function(t)
      renderer:render(t)
    end,
    on_end = function()
      renderer:render('\n\n' .. text.Header.User .. '\n\n')
      util.for_buffer_windows(current_buffer, function(win)
        vim.api.nvim_win_set_cursor(win, { renderer.line, 0 })
        if current_win == win then
          vim.cmd.startinsert()
        end
      end)
    end,
  }

  vim.api.nvim_buf_set_lines(current_buffer, context.insert_to, context.insert_to, false, { text.Waiting })
  vim.cmd.stopinsert()

  api.chat_completions(request, callbacks)
end

return M
