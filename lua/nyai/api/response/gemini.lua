return function(callbacks)
  local first = true
  local buffer = ''

  local function flush()
    if 0 < #buffer then
      local data = vim.json.decode(buffer)
      local c = data.candidates and data.candidates[1]

      vim.schedule(function()
        callbacks.on_text(vim.fn.join(
          vim.tbl_map(function(it)
            return it.text
          end, c.content.parts),
          '\n'
        ))
      end)

      buffer = ''
    end
  end

  local on_stream = function(err, line)
    if err then
      error('Failed to process a stream: ' .. tostring(err))
      return
    end

    if first then
      vim.schedule(callbacks.on_start)
      first = false
    end

    if line == '[{' then
      flush()
      buffer = '{'
      return
    end

    if line == ',' then
      return
    end

    if line == '}' then
      buffer = buffer .. '}'
      flush()
      return
    end

    buffer = buffer .. line
  end

  local on_complete = function()
    flush()
    vim.schedule(callbacks.on_end)
  end

  return {
    on_stream = on_stream,
    on_complete = on_complete,
  }
end
