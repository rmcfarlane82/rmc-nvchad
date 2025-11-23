---------------------------------------------------------------------------
-- NvChad Default Mappings
---------------------------------------------------------------------------
require "nvchad.mappings"

---------------------------------------------------------------------------
-- Basic Setup
---------------------------------------------------------------------------
local map = vim.keymap.set

-- Define DAP breakpoint icon (red emoji dot)
vim.fn.sign_define("DapBreakpoint", { text = "🛑", texthl = "", linehl = "", numhl = "" })

---------------------------------------------------------------------------
-- General Keymaps
---------------------------------------------------------------------------
-- Enter command mode quickly
map("n", ";", ":", { desc = "Enter command mode" })

-- Exit insert mode using 'jk'
map("i", "jk", "<ESC>", { desc = "Exit insert mode" })

-- Save file (works in all modes)
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<CR><ESC>", { desc = "Save file" })

---------------------------------------------------------------------------
-- Terminal Navigation
---------------------------------------------------------------------------
-- Exit terminal mode
map("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })

-- Move between windows from terminal mode
map("t", "<C-h>", [[<Cmd>wincmd h<CR>]], { desc = "Move to left window" })
map("t", "<C-j>", [[<Cmd>wincmd j<CR>]], { desc = "Move to below window" })
map("t", "<C-k>", [[<Cmd>wincmd k<CR>]], { desc = "Move to above window" })
map("t", "<C-l>", [[<Cmd>wincmd l<CR>]], { desc = "Move to right window" })

---------------------------------------------------------------------------
-- Window Resizing
---------------------------------------------------------------------------
-- Resize splits (Ctrl + Alt + direction)
map("n", "<C-A-h>", ":vertical resize +2<CR>", { desc = "Expand vertical split" })
map("n", "<C-A-l>", ":vertical resize -2<CR>", { desc = "Shrink vertical split" })
map("n", "<C-A-j>", ":resize +2<CR>", { desc = "Expand horizontal split" })
map("n", "<C-A-k>", ":resize -2<CR>", { desc = "Shrink horizontal split" })

---------------------------------------------------------------------------
-- Telescope & LSP
---------------------------------------------------------------------------
-- Go to implementation
map("n", "gi", "<cmd>Telescope lsp_implementations<CR>", { desc = "Go to implementation (Telescope)" })

-- Code actions (two styles: Telescope + native LSP)
map("n", "<leader>ca", "<cmd>Telescope lsp_code_action<CR>", { desc = "Telescope: show code actions" })
map("n", "<leader>.", vim.lsp.buf.code_action, { desc = "LSP: show code actions" })

---------------------------------------------------------------------------
-- Debugging (DAP) — For project / application debugging
---------------------------------------------------------------------------
local dap = require("dap")
local dapui = require("dapui")

-- Core DAP controls
map("n", "<F5>",  dap.continue,          { desc = "DAP: Start / Continue debugging" })
map("n", "<F9>",  dap.toggle_breakpoint, { desc = "DAP: Toggle breakpoint" })
map("n", "<F10>", dap.step_over,         { desc = "DAP: Step over" })
map("n", "<F11>", dap.step_into,         { desc = "DAP: Step into" })
map("n", "<S-F11>", dap.step_out,        { desc = "DAP: Step out" })

-- DAP session utilities
map("n", "<leader>dr", dap.repl.open, { desc = "DAP: Open REPL" })
map("n", "<leader>dl", dap.run_last,  { desc = "DAP: Run last session" })

-- DAP UI controls
map("n", "<leader>du", dapui.toggle, { desc = "DAP UI: Toggle panels" })
map("n", "<leader>de", dapui.eval,   { desc = "DAP UI: Evaluate expression" })
map("n", "<leader>dq", function()
  dapui.close({})
end, { desc = "DAP UI: Close all debug windows" })

---------------------------------------------------------------------------
-- Testing (Neotest) — For running & debugging tests
---------------------------------------------------------------------------
local neotest = require("neotest")

-- Run nearest test
map("n", "<leader>tn", function()
  neotest.run.run()
end, { desc = "Test: Run nearest test" })

-- Run all tests in current file
map("n", "<leader>tf", function()
  neotest.run.run(vim.fn.expand("%"))
end, { desc = "Test: Run all tests in current file" })

-- Run all tests in current project
map("n", "<leader>ta", function()
  neotest.run.run({ suite = true })
end, { desc = "Test: Run all tests in project" })

-- Debug nearest test using DAP
map("n", "<leader>td", function()
  neotest.run.run({ strategy = "dap" })
end, { desc = "Test: Debug nearest test (DAP)" })

-- Stop currently running tests
map("n", "<leader>ts", neotest.run.stop, { desc = "Test: Stop running tests" })

-- Rerun last suite
map("n", "<leader>tl", function()
  neotest.run.run_last()
end, { desc = "Test: Rerun last test suite" })

-- Test summary / results panels
map("n", "<leader>to", neotest.summary.toggle,      { desc = "Test: Toggle summary panel" })
map("n", "<leader>tp", neotest.output_panel.toggle, { desc = "Test: Toggle output panel" })

-- Diagnostics
map('n', "ge", vim.diagnostic.open_float, { desc = "Open Error" })
map('n', "[d", vim.diagnostic.get_prev, { desc = "Prev Error" })
map('n', "]d", vim.diagnostic.get_next, { desc = "Next Error" })
