-- JSON language server configuration with SchemaStore integration
local M = {}

function M.setup()
  local ok_schemastore, schemastore = pcall(require, "schemastore")
  local schema_list = {}
  if ok_schemastore then
    schema_list = schemastore.json.schemas()
  end

  vim.lsp.config("jsonls", {
    settings = {
      json = {
        schemas = vim.tbl_deep_extend(
          "force",
          {},
          schema_list,
          { { name = "package.json", fileMatch = { "package.json" } } }
        ),
        validate = { enable = true },
      },
    },
  })
end

return M
