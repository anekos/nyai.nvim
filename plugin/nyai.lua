local action = require('nyai.action')
local event = require('nyai.event')

local group = vim.api.nvim_create_augroup('Nyai', { clear = true })

vim.api.nvim_create_autocmd({ 'FileType' }, {
  group = group,
  pattern = 'nyai',
  callback = event.on_cr,
})

vim.api.nvim_create_user_command('Nyai', function(a)
  -- print(vim.inspect(a.args))
  action.run_with_template(a.args)
end, { nargs = 1, complete = require('nyai.completion').complete_templates, range = true })
