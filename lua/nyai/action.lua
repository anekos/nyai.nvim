local config = require('nyai.config')
local api = require('nyai.api')
local buffer = require('nyai.buffer')
local util = require('nyai.util')

local M = {}

local dir = vim.fn.expand('~/.config/nvim/nyai')

function M.run()
  local current_buffer = vim.api.nvim_get_current_buf()
  local current_win = vim.api.nvim_get_current_win()
  local parameters = buffer.get_parameters()

  local on_resp = function(body)
    local lines = { '<assistant>' }

    local last_line = vim.fn.getline('$')
    if last_line == '<WAITING>' then
      -- Remove last line
      vim.api.nvim_buf_set_lines(current_buffer, -2, -1, true, {})
    end

    for _, line in ipairs(vim.split(body.choices[1].message.content, '\n')) do -- FIXME ?
      table.insert(lines, line)
    end

    table.insert(lines, '.')
    table.insert(lines, '')
    table.insert(lines, '<user>')
    table.insert(lines, '')

    vim.api.nvim_buf_set_lines(current_buffer, -1, -1, true, lines)

    local num_lines = vim.api.nvim_buf_line_count(current_buffer)
    vim.api.nvim_win_set_cursor(current_win, { num_lines, 0 })
  end

  vim.api.nvim_buf_set_lines(current_buffer, -1, -1, true, { '', '<WAITING>' })

  api.chat_completions(parameters, function(body)
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

    local lines = { '<user>' }

    for _, line in ipairs(vim.split(embedded, '\n')) do
      table.insert(lines, line)
    end

    table.insert(lines, '.')
    table.insert(lines, '')
    table.insert(lines, '<assistant>')

    for _, line in ipairs(anwser) do -- FIXME ?
      table.insert(lines, line)
    end

    table.insert(lines, '')
    table.insert(lines, '<user>')

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
