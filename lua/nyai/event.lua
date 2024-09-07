local action = require('nyai.action')
local buffer = require('nyai.buffer')
local persistent = require('nyai.persistent')

local M = {}

function M.on_filetype()
  vim.keymap.set({ 'n', 'i' }, '<C-CR>', function()
    local context = buffer.get_context()
    if context ~= nil then
      vim.schedule(function()
        action.run(context)
      end)
    else
      vim.notify('No context found', 'warn')
    end
  end, { buffer = true })
end

function M.on_vim_leave_pre()
  persistent.save_state()
end

return M
