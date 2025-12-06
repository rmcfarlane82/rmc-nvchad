local scroll = require("config.snacks-scroll")
local statuscolumn = require("config.snacks-statuscolumn")
local picker = require("config.snacks-picker")
local explorer = require("config.snacks-explorer")


return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
		bigfile = { enabled = true },
		dashboard = { enabled = true },
		explorer = explorer,
		indent = { enabled = true },
		input = { enabled = true },
		keymap = { enabled = true },
		picker = picker,
		notifier = { enabled = true },
		quickfile = { enabled = true },
		scope = { enabled = true },
		scroll = scroll,
		statuscolumn = statuscolumn,
		words = { enabled = true },
		terminal = {
			enabled = true,
			shell = vim.fn.has("win32") == 1 and { "pwsh.exe", "-NoLogo" } or nil,
		},
		scratch = { enabled = false },
		animate = { enabled = true },
		bufdelete = { enabled = true },
		zen = { enabled = true },
		dim = { enabled = true },
	},
	keys = {
		{
			"<leader>lh",
			function()
				local buf = vim.api.nvim_get_current_buf()
				local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = buf })
				vim.lsp.inlay_hint.enable(not enabled, { bufnr = buf })

				vim.notify(
					"Inlay hints " .. (enabled and "disabled" or "enabled"),
					vim.log.levels.INFO,
					{ title = "LSP" }
				)
			end,
			desc = "Inlay hints Toggle",
			mode = { "n" },
		},
		{
			"<leader>zd",
			function()
				Snacks.dim()
			end,
			desc = "Dim on",
		},
		{
			"<leader>zD",
			function()
				Snacks.dim.disable()
			end,
			desc = "Dim off",
		},
		{
			"<leader>zz",
			function()
				Snacks.zen.zen()
			end,
			desc = "Zen toggle",
		},
		{
			"<leader>gl",
			function()
				Snacks.picker.git_log({
					on_show = function()
						vim.cmd.stopinsert()
					end,
					finder = "git_log",
					format = "git_log",
					preview = "git_show",
					confirm = "git_checkout",
					layout = { preset = "vertical" },
				})
			end,
			desc = "Git Log"
		},
		{
			"<leader>gb",
			function()
				Snacks.picker.git_branches({
					layout = "select",
					on_show = function()
						vim.cmd.stopinsert()
					end,
				})
			end,
			desc = "Git Branches"
		},
		{
			"<leader>gL",
			function()
				Snacks.picker.git_log_line({
					on_show = function()
						vim.cmd.stopinsert()
					end,
				}
				)
			end,
			desc = "Git Log Line"
		},
		{
			"<leader>gs",
			function()
				Snacks.picker.git_status({
					on_show = function()
						vim.cmd.stopinsert()
					end,
				})
			end,
			desc = "Git Status"
		},
		{ "<leader>gS", function() Snacks.picker.git_stash() end,             desc = "Git Stash" },
		{
			"<leader>gd",
			function()
				Snacks.picker.git_diff({
					on_show = function()
						vim.cmd.stopinsert()
					end,
				}
				)
			end,
			desc = "Git Diff (Hunks)"
		},
		{
			"<leader>gf",
			function()
				Snacks.picker.git_log_file({
					on_show = function()
						vim.cmd.stopinsert()
					end,
				}
				)
			end,
			desc = "Git Log File"
		},



		{
			"<leader>ff",
			function()
				Snacks.picker.smart({
					layout = { preset = "ivy" },
				})
			end,
			desc = "Smart Find Files"
		},
		{
			"<leader>fb",
			function()
				Snacks.picker.buffers({
					-- Focus the list so we don't auto-enter insert mode
					on_show = function()
						vim.cmd.stopinsert()
					end,
					layout = "sidebar",
					finder = "buffers",
					format = "buffer",
					hidden = false,
					unloaded = true,
					current = true,
					sort_lastused = true,
					win = {
						input = {
							keys = {
								["d"] = "bufdelete",
							},
						},
						list = { keys = { ["d"] = "bufdelete" } },
					},
				})
			end,
			desc = "Buffers"
		},
		{ "<leader>fg", function() Snacks.picker.grep() end,                  desc = "Grep" },
		{ "<leader>fh", function() Snacks.picker.command_history() end,       desc = "Command History" },
		{ "<leader>fn", function() Snacks.picker.notifications() end,         desc = "Notification History" },
		{ "<leader>e",  function() Snacks.explorer() end,                     desc = "File Explorer" },

		{ "<leader>bd", function() Snacks.bufdelete() end,                    desc = "Delete current buffer" },

		-- LSP
		{ "gd",         function() Snacks.picker.lsp_definitions() end,       desc = "Goto Definition" },
		{ "gD",         function() Snacks.picker.lsp_declarations() end,      desc = "Goto Declaration" },
		{ "gr",         function() Snacks.picker.lsp_references() end,        nowait = true,                  desc = "References" },
		{ "gi",         function() Snacks.picker.lsp_implementations() end,   desc = "Goto Implementation" },
		{ "gy",         function() Snacks.picker.lsp_type_definitions() end,  desc = "Goto T[y]pe Definition" },
		{ "gaI",        function() Snacks.picker.lsp_incoming_calls() end,    desc = "C[a]lls Incoming" },
		{ "gao",        function() Snacks.picker.lsp_outgoing_calls() end,    desc = "C[a]lls Outgoing" },
		{ "<leader>ss", function() Snacks.picker.lsp_symbols() end,           desc = "LSP Symbols" },
		{ "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
	},
}
