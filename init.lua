require("config.lazy")
require("config.options")
require("config.keymaps")
require("config.highlights").setup()
require("config.autocmds")

vim.cmd [[
  highlight Normal guibg=none
  highlight NonText guibg=none
  highlight Normal ctermbg=none
  highlight NonText ctermbg=none
]]
