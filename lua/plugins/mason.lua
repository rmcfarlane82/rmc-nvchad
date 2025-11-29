-- Mason registry & UI wiring to auto-install external LSP/formatter tools
return {
  "williamboman/mason.nvim",
  config = function ()
    require("configs.mason-config")
  end,
}
