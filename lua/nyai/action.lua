local api = require('nyai.api')
local config = require('nyai.config')
local util = require('nyai.util')

local M = {}

local dir = vim.fn.expand('~/.config/nvim/nyai')

function M.run(context)
  local current_buffer = vim.api.nvim_get_current_buf()
  local current_win = vim.api.nvim_get_current_win()

  local on_resp = function(body)
    local lines = { '# assistant', '' }

    if context.at_last then
      table.insert(lines, 1, '')
    end

    for _, line in ipairs(vim.split(body.choices[1].message.content, '\n')) do -- FIXME ?
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

  api.chat_completions(context.parameters, function(body)
    vim.schedule(function()
      on_resp(vim.fn.json_decode(body))
    end)
  end)
end

function M.run_with_template(name, replace)
  local file_path = dir .. '/' .. name .. '.nyai'
  local content = vim.fn.join(vim.fn.readfile(file_path), '\n')
  local embedded = string.gsub(content, '{{_select_}}', util.selected_text())
  embedded = string.gsub(embedded, '{{_buffer_}}', util.buffer_text())

  local parameters = {
    model = config.model.id,
    messages = {
      { role = 'user', content = embedded },
    },
  }

  local on_resp = function(body)
    local anwser = {}

    for _, line in ipairs(vim.split(body.choices[1].message.content, '\n')) do -- FIXME ?
      table.insert(anwser, line)
    end

    if replace then
      util.replace_selection(vim.fn.join(anwser, '\n'))
      return
    end

    local lines = { '# user' }

    for _, line in ipairs(vim.split(embedded, '\n')) do
      table.insert(lines, line)
    end

    table.insert(lines, '')
    table.insert(lines, '# assistant')
    table.insert(lines, '')

    for _, line in ipairs(anwser) do -- FIXME ?
      table.insert(lines, line)
    end

    table.insert(lines, '')
    table.insert(lines, '# user')
    table.insert(lines, '')

    util.new_buffer_with(lines)

    vim.bo.filetype = 'nyai'
  end

  api.chat_completions(parameters, function(body)
    vim.schedule(function()
      on_resp(vim.fn.json_decode(body))
    end)
  end)
end

return M
