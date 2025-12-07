return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {
    label = {
      uppercase = false, -- only use lowercase labels/keys
    },
  },
  keys = {
    {
      "<leader>j",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump()
      end,
      desc = "Flash jump",
    },
  },
}
