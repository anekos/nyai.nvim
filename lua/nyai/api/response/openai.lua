local for_stream = function(callbacks)
  local first = true

  local on_stream = function(err, line)
    if err then
      error('Failed to process a stream: ' .. tostring(err))
      return
    end

    if first then
      vim.schedule(callbacks.on_start)
      first = false
    end

    local body = line:gsub('data: ', '')
    if body == '' then
      return
    end

    if body == '[DONE]' then
      vim.schedule(callbacks.on_end)
      return
    end

    local data = vim.json.decode(body)

    if #data.choices == 0 then
      return
    end

    local text = data.choices[1].delta.content
    if text == vim.NIL or text == nil then
      return
    end
    if type(text) ~= 'string' then
      error('Invalid response from API: ' .. vim.inspect(data))
    end

    vim.schedule(function()
      callbacks.on_text(text)
    end)

    if data.choices[1].finish_reason == 'stop' then
      vim.schedule(callbacks.on_end)
    end
  end

  local on_complete = function() end

  return {
    on_stream = on_stream,
    on_complete = on_complete,
  }
end

local for_batch = function(callbacks)
  local on_response = function(data)
    vim.schedule(function()
      callbacks.on_start()
      callbacks.on_text(data.choices[1].message.content)
      callbacks.on_end()
    end)
  end

  return {
    on_response = on_response,
    on_complete = function() end,
  }
end

return function(stream)
  if stream then
    return for_stream
  end
  return for_batch
end
