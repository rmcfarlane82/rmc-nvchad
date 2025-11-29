return {
  "folke/which-key.nvim",
  event = "VeryLazy", -- or lazy = false
  opts = function()
    dofile(vim.g.base46_cache .. "whichkey")

    return {
      plugins = {
        marks = false,
        registers = false,
      },
    }
  end,
}
