local api = require('nyai.api')
local text = require('nyai.text')
local util = require('nyai.util')

local M = {}

function M.run(context)
  local current_win = vim.api.nvim_get_current_win()
  local current_buffer = vim.api.nvim_get_current_buf()
  local request = context.model.request(context)
  local renderer = require('nyai.buffer.renderer').new {
    win = current_win,
    buf = current_buffer,
    line = context.insert_to + 1,
    col = 1,
  }

  local callbacks = {
    on_start = function()
      renderer:render(text.Header.Assistant .. '\n\n')
    end,
    on_text = function(t)
      renderer:render(t)
    end,
    on_end = function()
      renderer:render('\n\n' .. text.Header.User .. '\n\n')
      renderer:remove_marker('Waiting')
      renderer:finish()

      util.for_buffer_windows(current_buffer, function(win)
        vim.api.nvim_win_set_cursor(win, { renderer.state.line, 0 })
        if current_win == win then
          vim.cmd.startinsert()
        end
      end)
    end,
    on_error = function(message)
      renderer:remove_marker('Waiting')
      renderer:finish()
      vim.notify(message, vim.log.levels.ERROR)
    end,
  }

  renderer:render('\n')
  renderer:render(text.Waiting .. '\n', { marker_name = 'Waiting' })
  vim.cmd.stopinsert()

  api.call(request, callbacks)
end

return M
