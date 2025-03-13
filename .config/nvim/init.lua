require("config/remap")
require("config/options")

if vim.g.vscode then
  require("config/vscode")
else
  require("config/lazy")

  vim.cmd('colorscheme gruvbox')
  vim.cmd [[ highlight Normal guibg=NONE ]]

  local function load_project_config()
    local project_config = vim.fs.find('.nvim.lua', { upward = true, type = 'file' })
    if #project_config > 0 then
      local config_path = project_config[1]
      dofile(config_path)
    end
  end

  load_project_config()
end
