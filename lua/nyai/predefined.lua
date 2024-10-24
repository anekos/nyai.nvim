local provider = require('nyai.provider')

local M = {}

M.models = {
  -- https://docs.anthropic.com/en/docs/about-claude/models#model-names
  provider.anthropic('Anthropic - Claude 3.5 Sonnet', 'claude-3-5-sonnet-20240620'),
  provider.anthropic('Anthropic - Claude 3 Opus', 'claude-3-opus-20240229'),
  provider.anthropic('Anthropic - Claude 3 Sonnect', 'claude-3-sonnet-20240229'),
  provider.anthropic('Anthropic - Claude 3 Haiku', 'claude-3-haiku-20240307'),
  -- https://platform.openai.com/docs/models/gpt-4o-mini
  provider.openai('OpenAI - GPT 4o', 'gpt-4o', true),
  provider.openai('OpenAI - GPT 4o mini', 'gpt-4o-mini', true),
  provider.openai('OpenAI - GPT 4 Turbo', 'gpt-4-turbo', true),
  provider.openai('OpenAI - GPT 3.5 Turbo', 'gpt-3.5-turbo', true),
  provider.openai('OpenAI - o1 preview', 'o1-preview', false),
  provider.openai('OpenAI - o1 mini', 'o1-mini', false),
  -- https://docs.perplexity.ai/guides/model-cards
  provider.perplexity('Perplexity - Sonar Small Online 8B', 'llama-3.1-sonar-small-128k-online'),
  provider.perplexity('Perplexity - Sonar Large Online 70B', 'llama-3.1-sonar-small-128k-online'),
  provider.perplexity('Perplexity - Sonar Huge Online 405B', 'llama-3.1-sonar-huge-128k-online'),
  provider.perplexity('Perplexity - Chat Small 8B', 'llama-3.1-sonar-small-128k-chat'),
  provider.perplexity('Perplexity - Chat Large 70B', 'llama-3.1-sonar-large-128k-chat'),
  provider.perplexity('Perplexity - Instruct Small 8B', 'llama-3.1-8b-instruct'),
  provider.perplexity('Perplexity - Instruct Large 70B', 'llama-3.1-70b-instruct'),
  -- No models
  provider.copilot('Github - Copilot'),
  provider.gemini('Google - Gemini'),
}

return M
