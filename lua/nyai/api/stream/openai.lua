return function(callbacks)
  local first = true

  return function(err, line)
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

    vim.schedule(function()
      if #data.choices == 0 then
        return
      end
      local text = data.choices[1].delta.content
      if text == vim.NIL then
        return
      end
      callbacks.on_text(text)
    end)
  end
end
