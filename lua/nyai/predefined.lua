local provider = require('nyai.provider')

local M = {}

M.models = {
  provider.openai('OpenAI - GPT 4o', 'gpt-4o'),
  provider.openai('OpenAI - GPT 4o mini', 'gpt-4o-mini'),
  provider.openai('OpenAI - GPT 4 Turbo', 'gpt-4-turbo'),
  provider.openai('OpenAI - GPT 3.5 Turbo', 'gpt-3.5-turbo'),
  provider.perplexity('Perplexity - Sonar Small Online 8B', 'llama-3.1-sonar-small-128k-online'),
  provider.perplexity('Perplexity - Sonar Large Online 70B', 'llama-3.1-sonar-small-128k-online'),
  provider.perplexity('Perplexity - Sonar Huge Online 405B', 'llama-3.1-sonar-huge-128k-online'),
  provider.perplexity('Perplexity - Chat Small 8B', 'llama-3.1-sonar-small-128k-chat'),
  provider.perplexity('Perplexity - Chat Large 70B', 'llama-3.1-sonar-large-128k-chat'),
  provider.perplexity('Perplexity - Instruct Small 8B', 'llama-3.1-8b-instruct'),
  provider.perplexity('Perplexity - Instruct Large 70B', 'llama-3.1-70b-instruct'),
  provider.openai('Github - Copilot', nil),
}

return M
