local M = {
  model = 'gpt-4o-turbo',
  api_end_point = 'https://api.openai.com/v1/chat/completions',
  api_key = vim.env.OPENAI_API_KEY,
}

return M
