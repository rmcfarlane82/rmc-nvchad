-- ~/.config/nvim/lua/themes/vsdark.lua
---@type Base46Table
local M = {}

-- Required by Base46 type: "dark" or "light"
M.type = "dark"

-- ============= base_30 (UI palette) =============
M.base_30 = {
  white = "#d4d4d4",
  black = "#1e1e1e",
  darker_black = "#191919",
  black2 = "#252526",
  one_bg = "#2a2a2a",
  one_bg2 = "#2f2f2f",
  one_bg3 = "#343434",
  grey = "#3e3e42",
  grey_fg = "#6c6c6c",
  grey_fg2 = "#7a7a7a",
  light_grey = "#858585",
  red = "#f44747",
  baby_pink = "#d7ba7d",
  pink = "#c586c0",
  line = "#2a2a2a",
  green = "#6a9955",
  vibrant_green = "#89d185",
  nord_blue = "#4fc1ff",
  blue = "#9cdcfe",
  seablue = "#4fc1ff",
  yellow = "#dcdcaa",
  sun = "#cca700",
  purple = "#c586c0",
  dark_purple = "#7e4ba0",
  teal = "#4ec9b0",
  orange = "#ce9178",
  cyan = "#4fc1ff",
  statusline_bg = "#1e1e1e",
  lightbg = "#1e1e1e",
  pmenu_bg = "#252526",
  folder_bg = "#9cdcfe",
}

-- ============= base_16 (core palette) =============
M.base_16 = {
  base00 = "#1e1e1e",
  base01 = "#252526",
  base02 = "#2a2a2a",
  base03 = "#3e3e42",
  base04 = "#858585",
  base05 = "#d4d4d4",
  base06 = "#e5e5e5",
  base07 = "#ffffff",
  base08 = "#f44747",
  base09 = "#ce9178",
  base0A = "#dcdcaa",
  base0B = "#6a9955",
  base0C = "#4ec9b0",
  base0D = "#9cdcfe",
  base0E = "#c586c0",
  base0F = "#b5cea8",
}

-- ============= optional extras =============
-- Extra groups you want to **add** (kept separate from polish_hl)
M.add_hl = {}

-- VS Dark+ synced TS + LSP colors
local VS_OFFWHITE = "#d4d4d4"
local VS_BLUE     = "#569cd6"   -- your darker blue choice
local VS_LBLUE    = "#9cdcfe"   -- light blue
local VS_YELLOW   = "#dcdcaa"
local VS_TEAL     = "#4ec9b0"
local VS_ORANGE   = "#ce9178"
local VS_PGREEN   = "#b5cea8"
local VS_PURPLE   = "#c586c0"
local VS_IFACE    = "#9ed6a2"   -- your interface color

M.polish_hl = M.polish_hl or {}
M.polish_hl.treesitter = {
  -- literals
  ["@string"]             = { fg = VS_ORANGE },
  ["@number"]             = { fg = VS_PGREEN },
  ["@boolean"]            = { fg = VS_PGREEN },

  -- functions / methods
  ["@function"]           = { fg = VS_YELLOW },
  ["@function.method"]    = { fg = VS_YELLOW },
  ["@method.call"]        = { fg = VS_YELLOW },
  ["@constructor"]        = { fg = VS_YELLOW },

  -- types / namespaces
  ["@type"]               = { fg = VS_TEAL },     -- classes/structs by default
  ["@type.interface"]     = { fg = VS_IFACE },    -- interfaces (TS supports this in c_sharp)
  ["@namespace"]          = { fg = VS_OFFWHITE }, -- match your LSP namespace color

  -- identifiers
  ["@variable"]           = { fg = VS_LBLUE },    -- match LSP variable
  ["@field"]              = { fg = VS_OFFWHITE }, -- match LSP field
  ["@property"]           = { fg = VS_OFFWHITE }, -- match LSP property
  ["@variable.parameter"] = { fg = VS_LBLUE },    -- match LSP parameter

  -- keywords
  ["@keyword"]            = { fg = VS_PURPLE },   -- if/return/for…
  ["@keyword.modifier"]   = { fg = VS_BLUE },     -- var/async/await/static
  ["@keyword.control"]    = { fg = "#d8a0df" },   -- to mirror your LSP controlKeyword
  RainbowDelimiterRed    = { fg = "#ffd700" },
  RainbowDelimiterYellow = { fg = "#dcdcaa" },
  RainbowDelimiterBlue   = { fg = "#9cdcfe" },
  RainbowDelimiterOrange = { fg = "#FFAC1C" },
  RainbowDelimiterGreen  = { fg = "#6a9955" },
  RainbowDelimiterViolet = { fg = "#c586c0" },
  RainbowDelimiterCyan   = { fg = "#4ec9b0" },
}

-- Keep your LSP semantic overrides too (higher prio, but same colors)
M.polish_hl.defaults = vim.tbl_deep_extend("force", M.polish_hl.defaults or {}, {
  ["@lsp.type.parameter.cs"]       = { fg = VS_LBLUE },
  ["@lsp.type.namespace.cs"]       = { fg = VS_OFFWHITE },
  ["@lsp.type.keyword.cs"]         = { fg = VS_BLUE },
  ["@lsp.type.extensionMethod.cs"] = { fg = VS_YELLOW },
  ["@lsp.type.interface.cs"]       = { fg = VS_IFACE },
  ["@lsp.type.property.cs"]        = { fg = VS_OFFWHITE },
  ["@lsp.type.controlKeyword.cs"]  = { fg = "#d8a0df" },
  ["@lsp.type.field.cs"]           = { fg = VS_OFFWHITE },
  ["@lsp.type.variable.cs"]        = { fg = VS_LBLUE },

  ["@variable.c_sharp"]            = { fg = VS_OFFWHITE },
  ["@type.c_sharp"]                = { fg = VS_OFFWHITE },
  ["@attribute.c_sharp"]           = { fg = VS_OFFWHITE },
  ["@lsp.typemod.constant.static.cs"] = { fg = VS_OFFWHITE },

  NeoTreeDirectoryIcon = { fg = "#ffcf4a" },
  DevIconCs = { fg = "#00b600"},
  DevIconCSharpProject = { fg = "#ffffff" },

  Pmenu = { fg = "#D4D4D4", bg = "#2D2D30" },
  PmenuSel =  { fg = "#ffffff" , bg = "#07AACC", bold = true },
  PmenuSbar = { bg = "#333333" },
  PmenuThumb = { bg = "#569Cd6" },
  NeoTreeCsharpProjectIcon = { fg = "#00b600" },
  NeoTreeSolutionIcon = { fg = VS_PURPLE }
})

return M
