local action = require('nyai.action')
local event = require('nyai.event')

local group = vim.api.nvim_create_augroup('Nyai', { clear = true })

vim.api.nvim_create_autocmd({ 'FileType' }, {
  group = group,
  pattern = 'nyai',
  callback = event.on_cr,
})

vim.api.nvim_create_user_command('Nyai', function(a)
  -- print(vim.inspect(a))
  -- print(vim.inspect(a.bang))
  if #a.args == 0 then
    local fname = vim.fn.strftime('~/nyai/%Y%m%d-%H%M.nyai')
    vim.cmd.edit(fname)
  else
    action.run_with_template(a.args, a.bang)
  end
end, { nargs = '*', complete = require('nyai.completion').complete_templates, range = true, bang = true })
