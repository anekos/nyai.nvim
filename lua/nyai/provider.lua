local P = require('nyai.parameter')

local M = {}

-- https://platform.openai.com/docs/models
M.OPENAI_ENDPOINT = 'https://api.openai.com/v1/chat/completions'

-- https://docs.perplexity.ai/reference/post_chat_completions
-- https://docs.perplexity.ai/guides/model-cards
M.PERPLEXITY_ENDPOINT = 'https://api.perplexity.ai/chat/completions'

M.GITHUB_COPILOT_ENDPOINT = 'https://api.githubcopilot.com/chat/completions'

function M.openai(name, id)
  return {
    name = name,
    id = id,
    api_endpoint = M.OPENAI_ENDPOINT,
    api_key = vim.env.OPENAI_API_KEY,
    -- https://platform.openai.com/docs/api-reference/chat
    parameters = {
      frequency_penalty = P.float,
      -- logit_bias = P.map  -- TODO
      logprobs = P.boolean,
      top_logprobs = P.integer,
      max_tokens = P.integer,
      -- n = P.integer,
      presence_penalty = P.float,
      -- response_format
      seed = P.integer,
      -- service_tier = 'string,
      stop = P.array(P.string),
      stream = P.boolean,
      temperature = P.float,
      top_p = P.float,
      -- tools = 'array',
      -- tool_choice = 'string',
      -- parallel_tool_calls = P.boolean,
    },
  }
end

function M.perplexity(name, id)
  return {
    name = name,
    id = id,
    api_endpoint = M.PERPLEXITY_ENDPOINT,
    api_key = vim.env.PERPLEXITY_API_KEY,
    -- https://docs.perplexity.ai/api-reference/chat-completions
    parameters = {
      max_tokens = P.integer,
      temperature = P.float,
      top_p = P.float,
      return_citations = P.boolean,
      search_domain_filter = P.array(P.string),
      -- return_images = P.boolean,
      -- return_related_questions = P.boolean,
      search_recency_filter = P.items { 'month', 'week', 'day', 'hour' },
      top_k = P.integer, -- 0 to 2048 inclusive
      presence_penalty = P.float, -- -2.0 to 2.0
      frequency_penalty = P.float, -- 0 to
    },
  }
end

function M.copilot(name)
  return {
    name = name,
    id = nil,
    api_endpoint = M.GITHUB_COPILOT_ENDPOINT,
    api_key = vim.env.GITHUB_TOKEN,
    parameters = {},
  }
end

function M.ollama(name, id)
  return {
    name = name,
    id = id,
    api_endpoint = 'http://localhost:11434/api/chat',
    api_key = nil,
    parameters = {},
  }
end

function M.ollama_generate(host, port)
  local curl = require('plenary.curl')

  if host == nil then
    host = 'localhost'
  end
  if port == nil then
    port = 11434
  end

  local api_endpoint = 'http://' .. host .. ':' .. tostring(port) .. '/api/tags'
  local response = curl.request {
    method = 'GET',
    url = api_endpoint,
  }
  return vim.tbl_map(function(it)
    return M.ollama('Ollama - ' .. it.name, it.model)
  end, vim.fn.json_decode(response.body)['models'])
end

return M
