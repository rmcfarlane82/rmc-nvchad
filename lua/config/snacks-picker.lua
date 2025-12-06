-- lua/config/snacks-picker.lua
local custom_vertical_preview_ratio = 0.75

---@type snacks.Config.picker
return {
	enabled = true,

	-- Folders to ignore
	exclude = { "bin", "obj", "node_modules", "dist", "build", ".git", ".venv" },

	-- File name formatting
	formatters = {
		file = {
			filename_first = true,
		},
	},

	win = {
		input = {
			keys = {
				-- your existing ones
				["<Esc>"] = { "focus_list", mode = { "n", "i" } },
				["jk"] = { "focus_list", mode = { "n", "i" } },

				-- preview scrolling with Shift+hjkl
				["J"] = { "preview_scroll_down", mode = { "i", "n" } },
				["K"] = { "preview_scroll_up", mode = { "i", "n" } },
				["H"] = { "preview_scroll_left", mode = { "i", "n" } },
				["L"] = { "preview_scroll_right", mode = { "i", "n" } },
			},
		},
	},

	layouts = {
		vertical = {
			config = function(layout)
				local preview_height = custom_vertical_preview_ratio
				local list_height = 1 - preview_height

				if not layout.layout then
					return layout
				end

				for _, section in ipairs(layout.layout) do
					if section.win == "preview" then
						section.height = preview_height
					elseif section.win == "list" then
						section.height = list_height
					end
				end

				return layout
			end,
		},
	},
}
