local M = {}

local function fill_lines(buf, n)
  local bottom = vim.fn.line('$')
  local right = #vim.fn.getline(bottom)
  local new_lines = {}
  for _ = 0, n, 1 do
    table.insert(new_lines, '')
  end
  vim.api.nvim_buf_set_text(buf, bottom - 1, right, bottom - 1, right, new_lines)
end

local function render(self, text)
  local line, col = self.line, self.col

  local buf = vim.api.nvim_get_current_buf()

  fill_lines(buf, line - vim.fn.line('$'))

  local lines = vim.split(text, '\n')
  vim.api.nvim_buf_set_text(buf, line - 1, col - 1, line - 1, col - 1, lines)

  self.line = #lines + line - 1
  if #lines == 1 then
    self.col = col + #lines[1]
  else
    self.col = #lines[#lines] + 1
  end

  if 1 < #lines then
    vim.api.nvim_win_set_cursor(self.win, { self.line, 0 })
  end
end

function M.new(otps)
  return vim.tbl_extend('error', otps, {
    render = render,
  })
end

return M
