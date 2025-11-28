return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {}, -- defaults are fine
  keys = {
    -- Jump: Ctrl+s in normal/visual/operator-pending mode
    { "<leader>j", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash Jump" },

    -- Treesitter jump: <leader>s in normal/visual/operator-pending mode
    -- { "<C-J>", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
  },
}
