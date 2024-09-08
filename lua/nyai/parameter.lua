local identity = function(x)
  return x
end

local M = {
  string = {
    description = 'string',
    completions = {},
    create = identity,
    validate = function()
      return true
    end,
  },

  boolean = {
    description = 'boolean',
    completions = { 'true', 'false' },
    create = function(value)
      return value == 'true'
    end,
    validate = function(value)
      return value == 'true' or value == 'false'
    end,
  },

  float = {
    description = 'float',
    completions = {},
    create = tonumber,
    validate = function(value)
      return tonumber(value) ~= nil
    end,
  },

  integer = {
    description = 'integer',
    completions = {},
    create = tonumber,
    validate = function(value)
      return tonumber(value) ~= nil
    end,
  },

  array = function(item)
    return {
      description = item.description .. '[]',
      completions = {},
      create = function(value)
        return vim.tbl_map(item.create, vim.split(value, ','))
      end,
      validate = function(value)
        return vim.iter(vim.split(value, ',')):all(item.validate)
      end,
    }
  end,

  items = function(items)
    return {
      description = vim.fn.join(items, '/'),
      completions = items,
      create = identity,
      validate = function(value)
        return vim.tbl_contains(items, value)
      end,
    }
  end,
}

return M
