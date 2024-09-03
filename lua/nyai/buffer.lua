local config = require('nyai.config')

local M = {}

local extract_role = function(line)
  if line == '# user' then
    return 'user'
  elseif line == '# assistant' then
    return 'assistant'
  elseif line == '# system' then
    return 'system'
  else
    return nil
  end
end

local try_to_set_parameters = function(line, parameters, overwrite)
  -- `@foo = bar`

  local key, value = string.match(line, '@(%w+)%s*=%s*(.+)')
  if key == nil or value == nil then
    return
  end

  value = vim.trim(value)

  if vim.tbl_contains({ 'model' }, key) then
    if not overwrite and parameters[key] then
      return
    end
    parameters[key] = value
  end
end

local function get_syntax_name(line, col)
  local current_syn_id = vim.fn.synID(line, col, 1)
  return vim.fn.synIDattr(current_syn_id, 'name')
end

local function cramp(lines)
  local start_blank_lines = 0
  local end_blank_lines = 0

  for _, line in ipairs(lines) do
    if line == '' then
      start_blank_lines = start_blank_lines + 1
    else
      break
    end
  end

  for i = #lines, 1, -1 do
    if lines[i] == '' then
      end_blank_lines = end_blank_lines + 1
    else
      break
    end
  end

  return vim.list_slice(lines, start_blank_lines + 1, #lines - end_blank_lines)
end

local function is_heading(syntax_name)
  if vim.tbl_contains({ 'markdownH1Delimiter' }, syntax_name) then
    return true
  end
end

local function is_comment(syntax_name)
  if vim.tbl_contains({ 'Comment' }, syntax_name) then
    return true
  end
end

local function read_buffer()
  local lines = {}
  local end_line = nil
  local current_line_number = vim.fn.line('.')
  local sections = {}
  local parameters = {}

  for ln = current_line_number + 1, vim.fn.line('$'), 1 do
    local syntax_name = get_syntax_name(ln, 1)
    local line = vim.fn.getline(ln)

    if is_comment(syntax_name) then
      try_to_set_parameters(line, parameters, true)
    elseif is_heading(syntax_name) then
      if extract_role(line) then
        end_line = ln - 1
        break
      end
    else
      table.insert(lines, line)
    end
  end

  if end_line == nil then
    end_line = vim.fn.line('$')
  end

  for ln = end_line, 1, -1 do
    local syntax_name = get_syntax_name(ln, 1)
    local line = vim.fn.getline(ln)

    if is_comment(syntax_name) then
      try_to_set_parameters(line, parameters, false)
    elseif is_heading(syntax_name) then
      local line_role = extract_role(line)
      if line_role ~= nil then
        table.insert(sections, 1, {
          start_line = ln,
          end_line = end_line,
          role = line_role,
          lines = cramp(lines),
        })
        end_line = ln - 1
        lines = {}
      end
    else
      table.insert(lines, 1, line)
    end
  end

  return sections, parameters
end

function M.get_context()
  -- returns { insert_to, at_last, parameters, messages }

  local result = {}
  local messages = {}

  local sections, parameters = read_buffer()

  if not sections or #sections < 1 or sections[#sections].role ~= 'user' then
    return nil
  end

  for _, section in ipairs(sections) do
    table.insert(messages, { role = section.role, content = vim.fn.join(section.lines) })
  end

  result.insert_to = sections[#sections].end_line
  result.at_last = sections[#sections].end_line == vim.fn.line('$')

  result.parameters = parameters
  result.messages = messages

  return result
end

function M.initialize(buf, fname, float)
  local lines = { '# user', '', '' }
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  if not fname then
    fname = M.new_filename()
  end
  vim.api.nvim_buf_set_name(buf, fname)

  if float then
    vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '<Cmd>wincmd c<CR>', { noremap = true })
    vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc>', '<Cmd>wincmd c<CR>', { noremap = true })
  end

  vim.api.nvim_buf_set_option(buf, 'filetype', 'nyai')
  vim.api.nvim_buf_set_option(buf, 'modified', false)
end

function M.ready_to_edit()
  vim.fn.cursor(3, 0)
  vim.cmd.startinsert()
end

function M.new_filename()
  local result = config.directory .. vim.fn.strftime('/%Y%m%d-%H%M.nyai')
  local no = 0
  while 0 <= vim.fn.bufnr(result) do
    no = no + 1
    result = vim.fn.substitute(result, [[\.nyai$]], '-' .. no .. '.nyai', '')
  end
  return result
end

return M
