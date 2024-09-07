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
  }
end

function M.perplexity(name, id)
  return {
    name = name,
    id = id,
    api_endpoint = M.PERPLEXITY_ENDPOINT,
    api_key = vim.env.PERPLEXITY_API_KEY,
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
