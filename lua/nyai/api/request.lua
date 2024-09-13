local M = {}

-- All functions return `headers, body properties, query parameters`

function M.api_key_header_and_body(key_header, key)
  return function(parameters)
    local headers = { [key_header] = key }

    return headers, parameters, {}
  end
end

return M
