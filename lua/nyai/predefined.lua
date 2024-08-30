local M = {}

-- https://platform.openai.com/docs/models
M.OPENAI_ENDPOINT = 'https://api.openai.com/v1/chat/completions'

-- https://docs.perplexity.ai/reference/post_chat_completions
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
    name = 'Perplexity - Lllama Sonar Small Chat',
    id = 'llama-3.1-sonar-small-128k-chat',
    api_endpoint = M.PERPLEXITY_ENDPOINT,
    api_key = vim.env.PERPLEXITY_API_KEY,
  },
  {
    name = 'Perplexity - Lllama Sonar Small Online',
    id = 'llama-3.1-sonar-small-128k-online',
    api_endpoint = M.PERPLEXITY_ENDPOINT,
    api_key = vim.env.PERPLEXITY_API_KEY,
  },
  {
    name = 'Perplexity - Lllama Sonar Large Chat',
    id = 'llama-3.1-sonar-large-128k-chat',
    api_endpoint = M.PERPLEXITY_ENDPOINT,
    api_key = vim.env.PERPLEXITY_API_KEY,
  },
  {
    name = 'Perplexity - Lllama Sonar Large Online',
    id = 'llama-3.1-sonar-large-128k-online',
    api_endpoint = M.PERPLEXITY_ENDPOINT,
    api_key = vim.env.PERPLEXITY_API_KEY,
  },
  {
    name = 'Perplexity - Lllama 8b Instruct',
    id = 'llama-3.1-8b-instruct',
    api_endpoint = M.PERPLEXITY_ENDPOINT,
    api_key = vim.env.PERPLEXITY_API_KEY,
  },
  {
    name = 'Perplexity - Lllama 70b Instruct',
    id = 'llama-3.1-70b-instruct.',
    api_endpoint = M.PERPLEXITY_ENDPOINT,
    api_key = vim.env.PERPLEXITY_API_KEY,
  },
  {
    name = 'Perplexity - Mistral 8x7b Instruct',
    id = 'mixtral-8x7b-instruct',
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
