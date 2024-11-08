local P = require('nyai.parameter')

local M = {}

local function merge(t1, t2)
  return vim.tbl_extend('force', t1, t2)
end

-- `request` function should returns `{headers, body, query}`

function M.anthropic(name, model_id)
  -- https://docs.anthropic.com/en/api/messages

  return {
    name = name,
    parameters = {
      max_tokens = P.integer,
      temperature = P.float,
      top_k = P.integer,
      top_p = P.float,
    },
    request = function(context)
      return {
        url = 'https://api.anthropic.com/v1/messages',
        headers = {
          ['x-api-key'] = vim.env.ANTHROPIC_API_KEY,
          ['anthropic-version'] = '2023-06-01',
        },
        body = merge({
          model = model_id,
          messages = context.messages,
          stream = true,
          max_tokens = 1024,
        }, context.parameters),
        response = require('nyai.api.response.anthropic'),
      }
    end,
  }
end

function M.gemini(name)
  -- https://ai.google.dev/gemini-api/docs/text-generation?lang=rest

  local api_key = vim.env.GEMINI_API_KEY

  return {
    name = name,
    parameters = {},
    request = function(context)
      local contents = {}
      for _, message in ipairs(context.messages) do
        local role = message.role
        if role == 'assistant' then
          role = 'model'
        end
        table.insert(contents, {
          role = role,
          parts = { { text = message.content } },
        })
      end
      return {
        url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:streamGenerateContent',
        query = { key = api_key },
        headers = {},
        body = { contents = contents },
        response = require('nyai.api.response.gemini'),
      }
    end,
    default_queries = {
      key = api_key,
    },
  }
end

function M.openai(name, model_id, stream)
  -- https://platform.openai.com/docs/api-reference/chat
  -- https://platform.openai.com/docs/models

  local api_key = vim.env.OPENAI_API_KEY

  return {
    name = name,
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
      temperature = P.float,
      top_p = P.float,
      -- tools = 'array',
      -- tool_choice = 'string',
      -- parallel_tool_calls = P.boolean,
    },
    request = function(context)
      return {
        url = 'https://api.openai.com/v1/chat/completions',
        headers = {
          ['Authorization'] = 'Bearer ' .. api_key,
        },
        body = merge({
          model = model_id,
          messages = context.messages,
          stream = stream,
        }, context.parameters),
        response = require('nyai.api.response.openai')(stream),
      }
    end,
  }
end

function M.perplexity(name, model_id)
  -- https://docs.perplexity.ai/api-reference/chat-completions

  local api_key = vim.env.PERPLEXITY_API_KEY

  return {
    name = name,
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
    request = function(context)
      return {
        url = 'https://api.perplexity.ai/chat/completions',
        headers = {
          ['Authorization'] = 'Bearer ' .. api_key,
        },
        body = merge({
          model = model_id,
          messages = context.messages,
          stream = true,
        }, context.parameters),
        response = require('nyai.api.response.openai')(true),
      }
    end,
  }
end

function M.copilot(name)
  local copilot = require('nyai.provider.chat.copilot')
  local api_key = copilot.authorize

  return {
    name = name,
    parameters = {},
    request = function(context)
      return {
        url = 'https://api.githubcopilot.com/chat/completions',
        headers = vim.tbl_extend('force', copilot.common_headers, {
          ['Authorization'] = 'Bearer ' .. api_key(),
        }),
        body = merge({
          model = context.model.id,
          messages = context.messages,
          stream = true,
        }, context.parameters),
        response = require('nyai.api.response.openai')(true),
      }
    end,
  }
end

function M.ollama(name, model_id)
  return {
    name = name,
    parameters = {},
    request = function(context)
      return {
        url = 'http://localhost:11434/api/chat',
        body = merge({
          model = model_id,
          messages = context.messages,
          stream = true,
        }, context.parameters),
        response = require('nyai.api.response.ollama'),
      }
    end,
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
