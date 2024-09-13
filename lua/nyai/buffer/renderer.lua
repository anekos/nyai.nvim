local M = {}

local function undojoin(self)
  if self.first then
    self.first = false
    return
  end
  vim.cmd.undojoin()
end

local function fill_lines(self, buf, n)
  local bottom = vim.fn.line('$')
  local right = #vim.fn.getline(bottom)
  local new_lines = {}

  for _ = 0, n, 1 do
    table.insert(new_lines, '')
  end

  undojoin(self)
  vim.api.nvim_buf_set_text(buf, bottom - 1, right, bottom - 1, right, new_lines)
end

local function render(self, text, opts)
  opts = opts or {}

  local line, col = self.line, self.col

  local buf = vim.api.nvim_get_current_buf()

  fill_lines(self, buf, line - vim.fn.line('$'))

  local lines = vim.split(text, '\n')

  undojoin(self)
  vim.api.nvim_buf_set_text(buf, line - 1, col - 1, line - 1, col - 1, lines)

  self.line = #lines + line - 1
  if #lines == 1 then
    self.col = col + #lines[1]
  else
    self.col = #lines[#lines] + 1
  end

  if opts.marker_name then
    if not self.markers[opts.marker_name] then
      self.markers[opts.marker_name] = {}
    end
    table.insert(self.markers[opts.marker_name], {
      start = { line = line, col = col },
      finish = { line = self.line, col = self.col },
      buf = buf,
    })
  end

  if 1 < #lines then
    vim.api.nvim_win_set_cursor(self.win, { self.line, 0 })
  end
end

local function remove_marker(self, name)
  for _, marker in ipairs(vim.fn.reverse(self.markers[name] or {})) do
    vim.api.nvim_buf_set_text(
      marker.buf,
      marker.start.line - 1,
      marker.start.col - 1,
      marker.finish.line - 1,
      marker.finish.col - 1,
      {}
    )
    -- TODO Consider col
    self.line = self.line - (marker.finish.line - marker.start.line)
  end

  self.markers[name] = nil
end

function M.new(otps)
  return vim.tbl_extend('error', otps, {
    first = true,
    render = render,
    markers = {},
    remove_marker = remove_marker,
  })
end

return M
