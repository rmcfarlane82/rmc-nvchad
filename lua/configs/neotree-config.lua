local neotree = require "neo-tree"
local components = require "neo-tree.sources.common.components"

local function dir_has_csproj(dir)
  local uv = vim.loop
  local h = uv.fs_scandir(dir)
  if not h then
    return false
  end
  while true do
    local name, t = uv.fs_scandir_next(h)
    if not name then
      break
    end
    if t == "file" and name:sub(-7):lower() == ".csproj" then
      return true
    end
  end
  return false
end

local original_icon = components.icon

components.icon = function(config, node, state)
  local item = original_icon(config, node, state)

  if node.type ~= "directory" then
    return item
  end

  local path = node.path or node:get_id()

  if dir_has_csproj(path) then
    item.text = ""
    item.highlight = "NeoTreeCsharpProjectIcon"
  elseif #vim.fn.glob(path .. "/*.sln*", false, true) > 0 then
    item.text = ""
    item.highlight = "NeoTreeSolutionIcon"
  end

  return item
end

neotree.setup {
  filesystem = {
    follow_current_file = { enabled = true, leave_dirs_open = false },
    hijack_netrw_behavior = "open_default",
    renderers = {
      file = {
        { "indent" },
        { "icon" },
        { "name" },
        { "diagnostics" },
        { "git_status" },
      },
      directory = {
        { "indent" },
        { "icon" },
        { "name" },
        { "git_status" },
      },
    },
    filtered_items = {
      hide_by_name = { "obj", "bin", "node_modules", "packages" },
      hide_by_pattern = {
        "*.csproj",
      },
    },
  },
  window = {
    mappings = {
      ["l"] = "open",
      ["h"] = "close_node",
      ["q"] = "close_window",
      ["<esc>"] = function()
        vim.cmd "wincmd p"
      end,
      ["F"] = function(state)
        local node = state.tree:get_node()
        local path = node:get_id()
        local cwd = node.type == "directory" and path or vim.fn.fnamemodify(path, ":h")
        require("telescope.builtin").find_files { cwd = cwd }
      end,
      ["G"] = function(state)
        local node = state.tree:get_node()
        local path = node:get_id()
        local cwd = node.type == "directory" and path or vim.fn.fnamemodify(path, ":h")
        require("telescope.builtin").live_grep { cwd = cwd }
      end,
    },
  },
}
