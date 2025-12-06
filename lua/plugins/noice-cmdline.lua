-- lua/plugins/noice-cmdline.lua
  return {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim" }, -- no notify dependency needed
    opts = {
      cmdline = {
        enabled = true,
        view = "cmdline_popup",
        format = { cmdline = { pattern = "^:", icon = "", lang = "vim" } },
      },
      messages = { enabled = false },
      notify = { enabled = false },
      lsp = { enabled = false },
      presets = { command_palette = true },
      views = {
        cmdline_popup = {
          position = { row = "30%", col = "50%" },
          size = { width = 60, height = "auto" },
          border = { style = "rounded" },
        },
      },
    },
  }

