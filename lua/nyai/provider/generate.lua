local M = {}

local function fim_encode(prefix, suffix)
  return '<｜fim▁begin｜>' .. prefix .. '<｜fim▁hole｜>' .. suffix .. '<｜fim▁end｜>'
end

function M.ollama(name, model_id, fim_encoding)
  return {
    name = name,
    parameters = {},
    request = function(prefix, suffix)
      local prompt
      if fim_encoding then
        prompt = fim_encode(prefix, suffix)
      else
        prompt = prefix
      end
      return {
        url = 'http://localhost:11434/api/generate',
        body = {
          model = model_id,
          prompt = prompt,
          raw = true,
          stream = false,
        },
      }
    end,
  }
end

return M
