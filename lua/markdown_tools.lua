-- Helper functions for Markdown checkboxes + preview keymaps
local M = {}

local checkbox_cycle = {
  [" "] = "x",
  ["x"] = " ",
  ["X"] = " ",
}

local checkbox_states = { " ", "-", "x" }

local function parse_checkbox(line)
  local indent, marker, state, rest = line:match "^(%s*)([%-%*%+])%s+%[(.)%](.*)$"
  if not indent then
    return nil
  end

  return {
    indent = indent,
    marker = marker,
    state = state,
    rest = rest,
  }
end

local function set_line(bufnr, row, line)
  vim.api.nvim_buf_set_lines(bufnr, row - 1, row, false, { line })
end

function M.toggle_checkbox(bufnr, row)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  row = row or vim.api.nvim_win_get_cursor(0)[1]

  local line = vim.api.nvim_buf_get_lines(bufnr, row - 1, row, false)[1]
  if not line then
    return
  end

  local parsed = parse_checkbox(line)
  if not parsed then
    vim.notify("No checkbox on this line", vim.log.levels.INFO, { title = "Markdown" })
    return
  end

  local next_state = checkbox_cycle[parsed.state] or checkbox_cycle[" "]
  local new_line = string.format("%s%s [%s]%s", parsed.indent, parsed.marker, next_state, parsed.rest)
  set_line(bufnr, row, new_line)
end

function M.cycle_checkbox(bufnr, row)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  row = row or vim.api.nvim_win_get_cursor(0)[1]

  local line = vim.api.nvim_buf_get_lines(bufnr, row - 1, row, false)[1]
  if not line then
    return
  end

  local parsed = parse_checkbox(line)
  if not parsed then
    vim.notify("No checkbox on this line", vim.log.levels.INFO, { title = "Markdown" })
    return
  end

  local index = 1
  for i, state in ipairs(checkbox_states) do
    if state == parsed.state then
      index = i
      break
    end
  end

  local next_state = checkbox_states[(index % #checkbox_states) + 1]
  local new_line = string.format("%s%s [%s]%s", parsed.indent, parsed.marker, next_state, parsed.rest)
  set_line(bufnr, row, new_line)
end

function M.setup_buffer(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  local map_opts = { buffer = bufnr, silent = true }
  vim.keymap.set("n", "<leader>mt", function()
    M.toggle_checkbox(bufnr)
  end, vim.tbl_extend("force", map_opts, { desc = "Markdown: Toggle checkbox" }))

  vim.keymap.set("n", "<leader>mc", function()
    M.cycle_checkbox(bufnr)
  end, vim.tbl_extend("force", map_opts, { desc = "Markdown: Cycle checkbox state" }))

  vim.keymap.set("n", "<leader>mp", "<cmd>Glow<CR>", vim.tbl_extend("force", map_opts, { desc = "Markdown: Preview with Glow" }))
end

return M
