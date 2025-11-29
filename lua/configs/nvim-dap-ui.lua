local dap, dapui = require("dap"), require("dapui")

local neotree_was_open = false

local function close_neotree_for_dap()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == "neo-tree" then
      neotree_was_open = true
      vim.cmd "Neotree close"
      return
    end
  end
  neotree_was_open = false
end

local function restore_neotree_after_dap()
  if neotree_was_open then
    vim.cmd "Neotree show left"
    neotree_was_open = false
  end
end

dapui.setup({
  layouts = {
    {
      elements = {
        "scopes",
        "breakpoints",
        "stacks",
        "watches",
      },
      size = 40,
      position = "left",
    },
    {
      elements = {
        "repl",
        "console",
      },
      size = 12,
      position = "bottom",
    },
  },
  floating = {
    border = "rounded",
  },
})

-- Auto open UI panels + console
dap.listeners.after.event_initialized["dapui_config"] = function()
  close_neotree_for_dap()
  dapui.open()
end

dap.listeners.before.event_terminated["dapui_config"] = function()
  local widgets = require("dap.ui.widgets")
  -- close sidebars but reopen console after closing
  dapui.close() -- close the left layout (scopes etc.)
--  require("dapui").open({ layout = 2 }) -- reopen bottom console layout
  restore_neotree_after_dap()
end

dap.listeners.before.event_exited["dapui_config"] = function()
  local widgets = require("dap.ui.widgets")
  dapui.close()
 -- require("dapui").open({ layout = 2 })
  restore_neotree_after_dap()
end
