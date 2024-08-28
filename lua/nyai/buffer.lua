local config = require('nyai.config')

local M = {}

local extract_role = function(line)
  if line == '<user>' then
    return 'user'
  elseif line == '<assistant>' then
    return 'assistant'
  elseif line == '<system>' then
    return 'system'
  else
    return nil
  end
end

local try_to_set_parameters = function(line, parameters)
  -- get key value from `foo = bar`
  local key, value = string.match(line, '(%w+) = (.+)')
  if key == nil or value == nil then
    return
  end
  print('Set key: ' .. key .. ' to value: ' .. value)
  parameters[key] = value
end

function M.get_parameters()
  local lines = vim.fn.getline(1, '$')
  local parameters = {
    model = config.model.id,
  }
  local messages = {}
  local current = nil

  for _, line in ipairs(lines) do
    if current == nil then
      local role = extract_role(line)

      if role == nil then
        try_to_set_parameters(line, parameters)
      else
        current = { role = role, content = {} }
      end

      goto continue
    end

    if line == '.' then
      table.insert(messages, current)
      current = nil
      goto continue
    end

    if current ~= nil and current.content ~= nil then
      table.insert(current.content, line)
    end

    ::continue::
  end

  for _, message in ipairs(messages) do
    message.content = vim.fn.join(message.content, '\n')
  end

  parameters.messages = messages

  return parameters
end

function M.initialize(buf, fname)
  local lines = { '<user>', '' }
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  if not fname then
    fname = config.new_filename()
  end
  vim.api.nvim_buf_set_name(buf, fname)

  vim.api.nvim_buf_set_option(buf, 'filetype', 'nyai')
  vim.api.nvim_buf_set_option(buf, 'modified', false)
end

function M.new_filename()
  local result =  config.directory .. '/' .. vim.fn.strftime('~/nyai/%Y%m%d-%H%M.nyai')
  local no = 0
  while 0 <= vim.fn.bufnr(result) do
    no = no + 1
    result = vim.fn.substitute(result, [[\.nyai$]], '-' .. no .. '.nyai', '')
  end
  return result
end

return M
