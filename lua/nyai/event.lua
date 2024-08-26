local persistent = require('nyai.persistent')
local action = require('nyai.action')
local vutil = require('nyai.util')

local M = {}

function M.on_cr()
  vim.keymap.set('i', '<CR>', function()
    if vim.fn.getline('.') == '.' then
      vim.schedule(function()
        action.run()
      end)
    else
      vutil.feedkeys('<CR>')
    end
  end, { expr = true, buffer = true })
end

function M.on_vim_leave_pre()
  persistent.save_state()
end

return M
