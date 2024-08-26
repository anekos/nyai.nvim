local M = {}

-- https://platform.openai.com/docs/models
M.OPENAI_ENDPOINT = 'https://api.openai.com/v1/chat/completions'

-- https://docs.perplexity.ai/reference/post_chat_completions
M.PERPLEXITY_ENDPOINT = 'https://api.perplexity.ai/chat/completions'

M.models = {
  ['OpenAI - GPT 4o'] = {
    model = 'chatgpt-4o-latest',
    api_endpoint = M.OPENAI_ENDPOINT,
    api_key = vim.env.OPENAI_API_KEY,
  },
  ['OpenAI - GPT 4o mini'] = {
    model = 'gpt-4o-mini',
    api_endpoint = M.OPENAI_ENDPOINT,
    api_key = vim.env.OPENAI_API_KEY,
  },
  ['OpenAI - GPT 4 Turbo'] = {
    model = 'gpt-4-turbo',
    api_endpoint = M.OPENAI_ENDPOINT,
    api_key = vim.env.OPENAI_API_KEY,
  },
  ['OpenAI - GPT 3.5 Turbo'] = {
    model = 'gpt-3.5-turbo',
    api_endpoint = M.OPENAI_ENDPOINT,
    api_key = vim.env.OPENAI_API_KEY,
  },
  ['Perplexity - Lllama Sonar Small Chat'] = {
    model = 'llama-3.1-sonar-small-128k-chat',
    api_endpoint = M.PERPLEXITY_ENDPOINT,
    api_key = vim.env.PERPLEXITY_API_KEY,
  },
  ['Perplexity - Lllama Sonar Small Online'] = {
    model = 'llama-3.1-sonar-small-128k-online',
    api_endpoint = M.PERPLEXITY_ENDPOINT,
    api_key = vim.env.PERPLEXITY_API_KEY,
  },
  ['Perplexity - Lllama Sonar Large Chat'] = {
    model = 'llama-3.1-sonar-large-128k-chat',
    api_endpoint = M.PERPLEXITY_ENDPOINT,
    api_key = vim.env.PERPLEXITY_API_KEY,
  },
  ['Perplexity - Lllama Sonar Large Online'] = {
    model = 'llama-3.1-sonar-large-128k-online',
    api_endpoint = M.PERPLEXITY_ENDPOINT,
    api_key = vim.env.PERPLEXITY_API_KEY,
  },
  ['Perplexity - Lllama 8b Instruct'] = {
    model = 'llama-3.1-8b-instruct',
    api_endpoint = M.PERPLEXITY_ENDPOINT,
    api_key = vim.env.PERPLEXITY_API_KEY,
  },
  ['Perplexity - Lllama 70b Instruct'] = {
    model = 'llama-3.1-70b-instruct.',
    api_endpoint = M.PERPLEXITY_ENDPOINT,
    api_key = vim.env.PERPLEXITY_API_KEY,
  },
  ['Perplexity - Mistral 8x7b Instruct'] = {
    model = 'mixtral-8x7b-instruct',
    api_endpoint = M.PERPLEXITY_ENDPOINT,
    api_key = vim.env.PERPLEXITY_API_KEY,
  },
}

return M
