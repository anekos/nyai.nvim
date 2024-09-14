local M = {}

function M.new(args)
  -- args = { win, buf, line, col }

  local state = vim.tbl_extend('error', {
    first = true,
    markers = {},
  }, args)

  vim.api.nvim_set_option_value('modifiable', false, { buf = state.buf })

  local function undojoin()
    if state.first then
      state.first = false
      return
    end
    vim.cmd.undojoin()
  end

  local function set_text(line1, col1, line2, col2, lines)
    vim.api.nvim_set_option_value('modifiable', true, { buf = state.buf })

    undojoin()
    vim.api.nvim_buf_set_text(state.buf, line1, col1, line2, col2, lines)

    vim.api.nvim_set_option_value('modifiable', false, { buf = state.buf })
  end

  local function fill_lines(n)
    local bottom = vim.api.nvim_buf_line_count(state.buf)
    local right = #vim.api.nvim_buf_get_lines(state.buf, bottom - 1, bottom, true)[1]
    local new_lines = {}

    for _ = 0, n, 1 do
      table.insert(new_lines, '')
    end

    set_text(bottom - 1, right, bottom - 1, right, new_lines)
  end

  local function render(_, text, opts)
    opts = opts or {}

    local line, col = state.line, state.col

    fill_lines(line - vim.api.nvim_buf_line_count(state.buf))

    local lines = vim.split(text, '\n')

    set_text(line - 1, col - 1, line - 1, col - 1, lines)

    state.line = #lines + line - 1
    if #lines == 1 then
      state.col = col + #lines[1]
    else
      state.col = #lines[#lines] + 1
    end

    if opts.marker_name then
      if not state.markers[opts.marker_name] then
        state.markers[opts.marker_name] = {}
      end
      table.insert(state.markers[opts.marker_name], {
        start = { line = line, col = col },
        finish = { line = state.line, col = state.col },
      })
    end

    if 1 < #lines then
      if vim.api.nvim_win_is_valid(state.win) then
        vim.api.nvim_win_set_cursor(state.win, { state.line, 0 })
      end
    end
  end

  local function remove_marker(_, name)
    for _, marker in ipairs(vim.fn.reverse(state.markers[name] or {})) do
      set_text(marker.start.line - 1, marker.start.col - 1, marker.finish.line - 1, marker.finish.col - 1, {})
      -- TODO Consider col
      state.line = state.line - (marker.finish.line - marker.start.line)
    end

    state.markers[name] = nil
  end

  local finish = function()
    vim.api.nvim_set_option_value('modifiable', true, { buf = state.buf })
  end

  return {
    render = render,
    remove_marker = remove_marker,
    finish = finish,
    state = state,
  }
end

return M
