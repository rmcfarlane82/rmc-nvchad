-- Custom LSP server wiring (ts_ls, jsonls, eslint, emmet, etc.) on top of NvChad defaults
local ok_lspconfig = pcall(require, "lspconfig")
if not ok_lspconfig then
  vim.notify("nvim-lspconfig is not available", vim.log.levels.ERROR)
  return
end

require("nvchad.configs.lspconfig").defaults()

local server_modules = {
  "configs.lsp.ts_ls",
  "configs.lsp.jsonls",
  "configs.lsp.eslint",
  "configs.lsp.emmet",
  "configs.lsp.roslyn",
}

for _, module in ipairs(server_modules) do
  local ok, mod = pcall(require, module)
  if ok and type(mod.setup) == "function" then
    mod.setup()
  else
    vim.notify(string.format("Failed to load LSP module: %s", module), vim.log.levels.WARN)
  end
end

local servers = {
  "html",
  "cssls",
  "marksman",
  "ts_ls",
  "jsonls",
  "eslint",
  "emmet_language_server",
}
vim.lsp.enable(servers)

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})
-- read :h vim.lsp.config for changing options of lsp servers
