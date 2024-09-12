local P = require('nyai.parameter')

local M = {}

function M.openai(name, id)
  return {
    name = name,
    id = id,
    api_endpoint = 'https://api.openai.com/v1/chat/completions',
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
    stream = require('nyai.api.stream.openai'),
  }
end

function M.perplexity(name, id)
  return {
    name = name,
    id = id,
    api_endpoint = 'https://api.perplexity.ai/chat/completions',
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
    stream = require('nyai.api.stream.openai'),
  }
end

function M.copilot(name)
  return {
    name = name,
    id = nil,
    api_endpoint = 'https://api.githubcopilot.com/chat/completions',
    api_key = function()
      return require('nyai.provider.copilot').authorize()
    end,
    parameters = {},
    headers = require('nyai.provider.copilot').common_headers,
    stream = require('nyai.api.stream.openai'),
  }
end

function M.ollama(name, id)
  return {
    name = name,
    id = id,
    api_endpoint = 'http://localhost:11434/api/chat',
    api_key = nil,
    parameters = {},
    stream = require('nyai.api.stream.ollama'),
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
