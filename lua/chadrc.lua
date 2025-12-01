-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}
-- VS Dark+ synced TS + LSP colors
local OFFWHITE = "#d4d4d4"
local BLUE = "#89b4fa" -- match Catppuccin's blue accent
local LBLUE = "#89dceb" -- light blue / sky
local YELLOW = "#dcdcaa"
local TEAL = "#4ec9b0"
local ORANGE = "#fab387"
local PGREEN = "#a6e3a1"
local PURPLE = "#cba6f7"
local IFACE = "#b4befe"
--local RED = "#f38ba8"
local PINK = "#f5c2e7"
local RB_PINK = "#FF00FF"
local RB_YELLOW = "#ffd866"
local RB_BLUE = "#6cb6ff"
local RB_ORANGE = "#ff8c42"
local RB_GREEN = "#7ee787"
local RB_VIOLET = "#d199ff"
local RB_CYAN = "#5ce1e6"
local COMMENT = "#6c7086"
local BASE = "#1e1e2e"
local SURFACE0 = "#45475a"
local SURFACE1 = "#585b70"

M.base46 = {
  theme = "default-dark",
  transparency = false,
  hl_override = (function()
    local base = {
      ["@string"] = { fg = ORANGE },
      ["@number"] = { fg = PGREEN },
      ["@boolean"] = { fg = PGREEN },

      -- functions / methods
      ["@function"] = { fg = YELLOW },
      ["@function.method"] = { fg = YELLOW },
      ["@method.call"] = { fg = YELLOW },
      ["@constructor"] = { fg = YELLOW },

      -- types / namespaces
      ["@type"] = { fg = TEAL }, -- classes/structs by default
      ["@type.interface"] = { fg = IFACE }, -- interfaces (TS supports this in c_sharp)
      ["@namespace"] = { fg = OFFWHITE }, -- match your LSP namespace color

      -- identifiers
      ["@variable"] = { fg = LBLUE }, -- match LSP variable
      ["@field"] = { fg = OFFWHITE }, -- match LSP field
      ["@property"] = { fg = OFFWHITE }, -- match LSP property
      ["@variable.parameter"] = { fg = LBLUE }, -- match LSP parameter

      -- keywords
      ["@keyword"] = { fg = PURPLE }, -- if/return/for…
      ["@keyword.modifier"] = { fg = BLUE }, -- var/async/await/static
      ["@keyword.control"] = { fg = PINK }, -- to mirror your LSP controlKeyword
      ["@variable.member"] = { fg = OFFWHITE },
--      Cursor = { fg = BASE, bg = BLUE },
--      lCursor = { fg = BASE, bg = LBLUE },
    }

    local lua_specific = {
      ["@keyword.lua"] = { fg = PURPLE },
      ["@function.lua"] = { fg = YELLOW },
      ["@function.call.lua"] = { fg = YELLOW },
      ["@variable.lua"] = { fg = LBLUE },
      ["@variable.member.lua"] = { fg = BLUE },
      ["@string.lua"] = { fg = ORANGE },
      ["@number.lua"] = { fg = PGREEN },
      ["@boolean.lua"] = { fg = PGREEN },
      ["@comment.lua"] = { fg = COMMENT },
    }

    local ts_specific = {
      ["@keyword.javascript"] = { fg = PURPLE },
      ["@keyword.typescript"] = { fg = PURPLE },
      ["@type.typescript"] = { fg = TEAL },
      ["@type.interface.typescript"] = { fg = IFACE },
      ["@function.call.typescript"] = { fg = YELLOW },
      ["@property.typescript"] = { fg = OFFWHITE },
      ["@variable.typescript"] = { fg = LBLUE },
      ["@variable.member.typescript"] = { fg = OFFWHITE },
      ["@punctuation.bracket.typescript"] = { fg = OFFWHITE },
    }

    local py_specific = {
      ["@variable.member.python"] = { fg = OFFWHITE },
      ["@function.method.call.python"] = { fg = YELLOW },
    }

    return vim.tbl_extend("force", base, lua_specific, ts_specific, py_specific)
  end)(),
  -- hl_override = {
  -- 	Comment = { italic = true },
  -- 	["@comment"] = { italic = true },
  -- },
  hl_add = {
    RainbowDelimiterRed = { fg = RB_PINK },
    RainbowDelimiterYellow = { fg = RB_YELLOW },
    RainbowDelimiterBlue = { fg = RB_BLUE },
    RainbowDelimiterOrange = { fg = RB_ORANGE },
    RainbowDelimiterGreen = { fg = RB_GREEN },
    RainbowDelimiterViolet = { fg = RB_VIOLET },
    RainbowDelimiterCyan = { fg = RB_CYAN },
    -- C# semantics
    ["@lsp.type.parameter.cs"] = { fg = LBLUE },
    ["@lsp.type.namespace.cs"] = { fg = OFFWHITE },
    ["@lsp.type.keyword.cs"] = { fg = BLUE },
    ["@lsp.type.extensionMethod.cs"] = { fg = YELLOW },
    ["@lsp.type.interface.cs"] = { fg = IFACE },
    ["@lsp.type.property.cs"] = { fg = OFFWHITE },
    ["@lsp.type.controlKeyword.cs"] = { fg = PINK },
    ["@lsp.type.field.cs"] = { fg = OFFWHITE },
    ["@lsp.type.variable.cs"] = { fg = LBLUE },
    ["@lsp.type.class.cs"] = { fg = TEAL },
    ["@lsp.typemod.constant.static.cs"] = { fg = OFFWHITE },
    ["@variable.member.c_sharp"] = { fg = OFFWHITE },
    ["@variable.c_sharp"] = { fg = LBLUE },
    ["@type.c_sharp"] = { fg = TEAL },
    ["@function.method.call.c_sharp"] = { fg = YELLOW },
    ["@attribute.c_sharp"] = { fg = OFFWHITE },
    ["@module.c_sharp"] = { fg = OFFWHITE },
    ["@type.builtin.c_sharp"] = { fg = BLUE },
    ["@keyword.exception.c_sharp"] = { fg = PURPLE },
    ["@keyword.modifier.c_sharp"] = { fg = BLUE },
    ["@keyword.type.c_sharp"] = { fg = BLUE },

    -- Lua semantics
    ["@lsp.type.variable.lua"] = { fg = LBLUE },
    ["@lsp.type.parameter.lua"] = { fg = LBLUE },
    ["@lsp.type.property.lua"] = { fg = OFFWHITE },
    ["@lsp.type.function.lua"] = { fg = YELLOW },
    ["@function.call.lua"] = { fg = YELLOW },
    ["@variable.member.lua"] = { fg = BLUE },

    -- TypeScript semantics
    ["@lsp.type.parameter.typescript"] = { fg = LBLUE },
    ["@lsp.type.property.typescript"] = { fg = OFFWHITE },
    ["@lsp.type.variable.typescript"] = { fg = LBLUE },
    ["@lsp.type.interface.typescript"] = { fg = IFACE },
    ["@lsp.type.typeParameter.typescript"] = { fg = TEAL },
    ["@lsp.type.enumMember.typescript"] = { fg = OFFWHITE },

    -- Python semantics
    ["@variable.member.python"] = { fg = OFFWHITE },
    ["@function.method.call.python"] = { fg = YELLOW },
    ["@function.builtin.python"] = { fg = BLUE },
    ["@function.call.python"] = { fg = YELLOW },
    ["@module.python"] = { fg = OFFWHITE },
    ["@keyword.repeat.python"] = { fg = PURPLE },

    NeoTreeDirectoryIcon = { fg = RB_YELLOW },
    DevIconCs = { fg = PGREEN },
    DevIconCSharpProject = { fg = OFFWHITE },

    Pmenu = { fg = OFFWHITE, bg = BASE },
    PmenuSel = { fg = BASE, bg = BLUE, bold = true },
    PmenuSbar = { bg = SURFACE0 },
    PmenuThumb = { bg = SURFACE1 },
    NeoTreeCsharpProjectIcon = { fg = PGREEN },
    NeoTreeSolutionIcon = { fg = PURPLE },

-- Flash.nvim highlights: bright labels + dimmed backdrop
    FlashLabel = { fg = BASE, bg = PINK, bold = true },
    FlashMatch = { fg = BASE, bg = PGREEN, bold = true },
    FlashCurrent = { fg = BASE, bg = PGREEN, bold = true },
    FlashBackdrop = { fg = SURFACE0 },

  },
}

M.nvdash = {
  load_on_startup = true,
  header = {
    "███╗   ██╗███████╗██████╗ ██████╗ ",
    "████╗  ██║██╔════╝██╔══██╗██╔══██╗",
    "██╔██╗ ██║█████╗  ██████╔╝██║  ██║",
    "██║╚██╗██║██╔══╝  ██╔══██╗██║  ██║",
    "██║ ╚████║███████╗██║  ██║██████╔╝",
    "╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝╚═════╝ ",
    "                                  ",
  },
}

M.ui = {
  telescope = {
    style = "bordered",
  },
  tabufline = {
    lazyload = false,
  }
}

return M
