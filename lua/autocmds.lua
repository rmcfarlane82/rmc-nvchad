require "nvchad.autocmds"
local markdown_tools = require "markdown_tools"
if vim.loop.os_uname().version:match("Windows") then
  vim.opt.shell = "pwsh.exe"                     -- or "powershell.exe"
  vim.opt.shellcmdflag =
    "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
  vim.opt.shellquote = ""
  vim.opt.shellxquote = ""
end

-- Use your Windows Terminal scheme (Campbell shown here).
-- Replace the hexes if you use another scheme.
local p = {
  [0]  = "#0C0C0C",  -- black
  [1]  = "#C50F1F",  -- red
  [2]  = "#13A10E",  -- green
  [3]  = "#C19C00",  -- yellow
  [4]  = "#0037DA",  -- blue
  [5]  = "#881798",  -- magenta
  [6]  = "#3A96DD",  -- cyan
  [7]  = "#CCCCCC",  -- white
  [8]  = "#767676",  -- brBlack
  [9]  = "#E74856",  -- brRed
  [10] = "#16C60C",  -- brGreen
  [11] = "#F9F1A5",  -- brYellow
  [12] = "#3B78FF",  -- brBlue
  [13] = "#B4009E",  -- brMagenta
  [14] = "#61D6D6",  -- brCyan
  [15] = "#F2F2F2",  -- brWhite
}

local function set_term_colors()
  for i = 0, 15 do
    vim.g["terminal_color_" .. i] = p[i]
  end
end

-- Ensure truecolor and reapply after any theme change
vim.opt.termguicolors = true
vim.api.nvim_create_autocmd({ "VimEnter", "ColorScheme" }, { callback = set_term_colors })
vim.api.nvim_create_autocmd("TermOpen", { callback = set_term_colors })

set_term_colors()

local markdown_group = vim.api.nvim_create_augroup("MarkdownTweaks", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = markdown_group,
  pattern = { "markdown", "mdx", "md" },
  callback = function(event)
    local opts = vim.opt_local
    opts.wrap = true
    opts.linebreak = true
    opts.spell = true
    opts.spellcapcheck = ""
    opts.spelloptions = { "camel" }
    opts.conceallevel = 2
    opts.colorcolumn = ""
    opts.textwidth = 0
    opts.tabstop = 2
    opts.shiftwidth = 2
    opts.softtabstop = 2
    opts.expandtab = true
    opts.swapfile = false
    opts.signcolumn = "yes"
    opts.list = false
    vim.opt_local.formatoptions:append "t"
    vim.opt_local.formatoptions:append "n"

    vim.bo[event.buf].commentstring = "> %s"

    markdown_tools.setup_buffer(event.buf)
  end,
})

--vim.api.nvim_create_autocmd("BufDelete", {
--  callback = function()
--    local bufs = vim.t.bufs
--    if #bufs == 1 and vim.api.nvim_buf_get_name(bufs[1]) == "" then
--      vim.cmd "Nvdash"
--    end
--  end,
--})
