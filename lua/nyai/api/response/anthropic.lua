local ignore_event = {
  'content_block_delta',
  'content_block_start',
  'content_block_stop',
  'message_delta',
  'message_start',
  'ping',
}

local ignore_data_types = {
  'content_block',
  'content_block_start',
  'content_block_delta',
  'content_block_stop',
  'message_start',
  'message_stop',
  'ping',
}

return function(callbacks)
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

    local stream_type, body = line:match([[(%w+): (.*)]])
    if stream_type == nil then
      return
    end

    if stream_type == 'event' then
      if body == 'message_stop' then
        vim.schedule(callbacks.on_end)
        return
      end

      if vim.list_contains(ignore_event, body) then
        return
      end
    end

    if stream_type == 'data' then
      local data = vim.json.decode(body)

      if data.type == 'error' then
        error(data.error.message)
      end

      if data.delta then
        if data.delta.type == 'text_delta' then
          vim.schedule(function()
            callbacks.on_text(data.delta.text)
          end)
          return
        end

        if data.delta.stop_reason ~= nil then
          return
        end
      end

      if vim.list_contains(ignore_data_types, data.type) then
        return
      end
    end
  end

  local on_complete = function() end

  return {
    on_stream = on_stream,
    on_complete = on_complete,
  }
end
