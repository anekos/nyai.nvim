local api = require('nyai.api')
local buffer = require('nyai.buffer')

vim.api.nvim_create_user_command('Nyai', function()
  local current_buffer = vim.api.nvim_get_current_buf()
  local current_win = vim.api.nvim_get_current_win()
  local parameters = buffer.get_parameters()

  local on_resp = function(body)
    local lines = { '', '<ASSISTANT>' }

    for _, line in ipairs(vim.split(body.choices[1].message.content, '\n')) do -- FIXME ?
      table.insert(lines, line)
    end

    table.insert(lines, '.')
    table.insert(lines, '')
    table.insert(lines, '<USER>')

    vim.api.nvim_buf_set_lines(current_buffer, -1, -1, true, lines)

    local num_lines = vim.api.nvim_buf_line_count(current_buffer)
    vim.api.nvim_win_set_cursor(current_win, { num_lines, 0 })
  end

  api.chat_completions(parameters, function(body)
    vim.schedule(function()
      on_resp(vim.fn.json_decode(body))
    end)
  end)
end, {})
