-- DAP core adapters/UI wiring for debugging workflows
return {
  -- Core DAP
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    config = function()
      require("configs.nvim-dap")
    end,
  },

  -- DAP UI
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "nvim-neotest/nvim-nio", "mfussenegger/nvim-dap" },
    config = function()
      require("configs.nvim-dap-ui")
    end,
  },

  -- Neotest
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "Issafalcon/neotest-dotnet",
    },
    config = function()
      require("neotest").setup({
        adapters = { require("neotest-dotnet") },
      })
    end,
  },
}
