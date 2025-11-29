-- General Neovim options layered on NvChad defaults
require "nvchad.options"

-- add yours here!

local o = vim.opt

o.autoread = true
vim.cmd [[autocmd FocusGained,BufEnter * checktime]]

o.cursorlineopt ='both' -- to enable cursorline!
o.shiftwidth = 4
o.tabstop = 4
o.softtabstop = 4
o.smartindent = true
o.wrap = false
o.guicursor = table.concat({
    "n-v-c:block",       -- normal/visual/command: block
    "i-ci-ve:ver25",     -- insert/cmd-line insert: vertical bar 25%
    "t:ver25",           -- terminal-mode: vertical bar so terminal buffer insert matches
    "r-cr:hor20",        -- replace modes: horizontal bar
    "o:hor50",           -- operator-pending
    "sm:block-blinkwait175-blinkoff150-blinkon175", -- showmatch
  }, ",")
