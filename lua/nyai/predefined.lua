local M = {}

-- https://platform.openai.com/docs/models
M.OPENAI_ENDPOINT = 'https://api.openai.com/v1/chat/completions'

-- https://docs.perplexity.ai/reference/post_chat_completions
-- https://docs.perplexity.ai/guides/model-cards
M.PERPLEXITY_ENDPOINT = 'https://api.perplexity.ai/chat/completions'

M.GITHUB_COPILOT_ENDPOINT = 'https://api.githubcopilot.com/chat/completions'

M.models = {
  {
    name = 'OpenAI - GPT 4o',
    id = 'gpt-4o',
    api_endpoint = M.OPENAI_ENDPOINT,
    api_key = vim.env.OPENAI_API_KEY,
  },
  {
    name = 'OpenAI - GPT 4o mini',
    id = 'gpt-4o-mini',
    api_endpoint = M.OPENAI_ENDPOINT,
    api_key = vim.env.OPENAI_API_KEY,
  },
  {
    name = 'OpenAI - GPT 4 Turbo',
    id = 'gpt-4-turbo',
    api_endpoint = M.OPENAI_ENDPOINT,
    api_key = vim.env.OPENAI_API_KEY,
  },
  {
    name = 'OpenAI - GPT 3.5 Turbo',
    id = 'gpt-3.5-turbo',
    api_endpoint = M.OPENAI_ENDPOINT,
    api_key = vim.env.OPENAI_API_KEY,
  },
  {
    name = 'Perplexity - Sonar Small Online 8B',
    id = 'llama-3.1-sonar-small-128k-online',
    api_endpoint = M.PERPLEXITY_ENDPOINT,
    api_key = vim.env.PERPLEXITY_API_KEY,
  },
  {
    name = 'Perplexity - Sonar Large Online 70B',
    id = 'llama-3.1-sonar-small-128k-online',
    api_endpoint = M.PERPLEXITY_ENDPOINT,
    api_key = vim.env.PERPLEXITY_API_KEY,
  },
  {
    name = 'Perplexity - Sonar Huge Online 405B',
    id = 'llama-3.1-sonar-huge-128k-online',
    api_endpoint = M.PERPLEXITY_ENDPOINT,
    api_key = vim.env.PERPLEXITY_API_KEY,
  },
  {
    name = 'Perplexity - Chat Small 8B',
    id = 'llama-3.1-sonar-small-128k-chat',
    api_endpoint = M.PERPLEXITY_ENDPOINT,
    api_key = vim.env.PERPLEXITY_API_KEY,
  },
  {
    name = 'Perplexity - Chat Large 70B',
    id = 'llama-3.1-sonar-large-128k-chat',
    api_endpoint = M.PERPLEXITY_ENDPOINT,
    api_key = vim.env.PERPLEXITY_API_KEY,
  },
  {
    name = 'Perplexity - Instruct Small 8B',
    id = 'llama-3.1-8b-instruct',
    api_endpoint = M.PERPLEXITY_ENDPOINT,
    api_key = vim.env.PERPLEXITY_API_KEY,
  },
  {
    name = 'Perplexity - Instruct Large 70B',
    id = 'llama-3.1-70b-instruct',
    api_endpoint = M.PERPLEXITY_ENDPOINT,
    api_key = vim.env.PERPLEXITY_API_KEY,
  },
  {
    name = 'Github - Copilot',
    id = nil,
    api_endpoint = M.GITHUB_COPILOT_ENDPOINT,
    api_key = vim.env.GITHUB_TOKEN,
  },
}

return M
