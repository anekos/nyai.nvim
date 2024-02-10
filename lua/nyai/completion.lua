local M = {}

local dir = vim.fn.expand('~/.config/nvim/nyai')

function M.complete_templates()
  local scan = vim.loop.fs_scandir(dir)

  if not scan then
    print('Directory not found: ' .. dir)
    return {}
  end

  local files = {}

  while true do
    local name, type = vim.loop.fs_scandir_next(scan)
    if not name then
      break
    end

    if type == 'file' then
      local name_without_ext = name:match('(.+)%.nyai')
      if name_without_ext then
        table.insert(files, name_without_ext)
      end
    end
  end

  return files
end

return M
