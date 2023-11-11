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
    model = 'gpt-3.5-turbo',
  }
  local messages = {}
  local current = nil

  for _, line in ipairs(lines) do
    local role = extract_role(line)

    if role == nil then
      try_to_set_parameters(line, parameters)
    else
      current = { role = role, content = {} }
      goto continue
    end

    if current == nil then
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

return M
