-- Configure Neo-tree file explorer behavior/look
return {
  {
    "nvim-tree/nvim-tree.lua",
    enabled = false,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    cmd = "Neotree",
    keys = {
      { "<C-e>", ":Neotree focus<CR>", { desc = "Neotree toggle filesystem" } },
    },
    config = function ()
     require("configs.neotree-config")
    end
  },
}
