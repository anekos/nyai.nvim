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
      frequency_penalty = 'float',
      logit_bias = 'table',
      logprobs = 'boolean',
      top_logprobs = 'integer',
      max_tokens = 'integer',
      -- n = 'integer',
      presence_penalty = 'float',
      -- response_format
      seed = 'integer',
      -- service_tier = 'string,
      stop = 'string | string[]',
      stream = 'boolean',
      temperature = 'float',
      top_p = 'float',
      -- tools = 'array',
      -- tool_choice = 'string',
      -- parallel_tool_calls = 'boolean',
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
      max_tokens = 'integer',
      temperature = 'float',
      top_p = 'float',
      return_citations = 'boolean',
      search_domain_filter = 'string[]',
      -- return_images = 'boolean',
      -- return_related_questions = 'boolean',
      search_recency_filter = { 'month', 'week', 'day', 'hour' },
      top_k = 'integer', -- 0 to 2048 inclusive
      presence_penalty = 'float', -- -2.0 to 2.0
      frequency_penalty = 'float', -- 0 to
    },
  }
end

function M.copilot(name)
  return {
    name = name,
    id = nil,
    api_endpoint = M.GITHUB_COPILOT_ENDPOINT,
    api_key = vim.env.GITHUB_TOKEN,
  }
end

return M
