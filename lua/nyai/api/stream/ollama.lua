return function(callbacks)
  local first = true

  return function(err, line)
    if err then
      error('Failed to process a stream: ' .. tostring(err))
      return
    end

    local data = vim.json.decode(line)

    if first then
      vim.schedule(callbacks.on_start)
      first = false
    end

    vim.schedule(function()
      callbacks.on_text(data.message.content)
    end)

    if data.done then
      vim.schedule(callbacks.on_end)
    end
  end
end
