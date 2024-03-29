local M = {}

function M.feedkeys(keys)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), 'n', false)
end

function M.selected_text()
  local old = vim.fn.getreg('s', 1)
  vim.cmd('silent normal! gv"sy')
  local result = vim.fn.getreg('s', 1)
  vim.fn.setreg('s', old, 1)
  return result
end

function M.new_buffew_with(lines)
  vim.cmd.tabnew()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(0, buf)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
end

function M.replace_selection(content)
  local old = vim.fn.getreg('s', 1)
  vim.fn.setreg('s', content, 1)
  vim.cmd('silent normal! gv"sp')
  vim.fn.setreg('s', old, 1)
end

return M
