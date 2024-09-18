local action = require('nyai.action')
local buffer = require('nyai.buffer')
local persistent = require('nyai.persistent')

local M = {}

function M.on_filetype()
  vim.keymap.set({ 'n', 'i' }, '<C-CR>', function()
    local context = buffer.get_context(true)
    if context ~= nil then
      if 0 < #context.errors then
        vim.notify(vim.fn.join(context.errors, '\n'), vim.log.levels.ERROR)
        return
      end

      vim.schedule(function()
        action.run(context)
      end)
    else
      vim.notify('Not in user context', vim.log.levels.WARN)
    end
  end, { buffer = true })
end

function M.on_vim_leave_pre()
  persistent.save_state()
end

return M
