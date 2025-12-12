local Snacks = require("snacks")
local scroll = require("config.snacks-scroll")
local statuscolumn = require("config.snacks-statuscolumn")
local picker = require("config.snacks-picker")
local user_secrets = require("config.user_secrets")
local dotnet_runner = require("config.dotnet-runner")
local buffer_sidebar_width = 50

dotnet_runner.setup()

local function terminal_label(term)
	if not term or not term.buf or not vim.api.nvim_buf_is_valid(term.buf) then
		return ("#%s %s"):format(term and term.id or "?", "terminal")
	end

	local meta = vim.b[term.buf].snacks_terminal or {}
	local cmd = meta.cmd
	if type(cmd) == "table" then
		cmd = table.concat(cmd, " ")
	end

	local label = cmd or vim.api.nvim_buf_get_name(term.buf):gsub("^term://", "")
	label = label ~= "" and label or ("terminal %d"):format(term.buf)

	return ("#%d %s"):format(meta.id or term.id or term.buf, label)
end

local function pick_terminal_to_close()
	local terms = Snacks.terminal.list()
	if #terms == 0 then
		vim.notify("No terminals to close", vim.log.levels.INFO, { title = "Terminals" })
		return
	end

	Snacks.picker.select(terms, {
		prompt = "Close which terminal?",
		format_item = function(item)
			return terminal_label(item)
		end,
		snacks = {
			focus = "list",
			auto_close = false,
			layout = { preset = "default" },
			preview = function(ctx)
				ctx.preview:reset()
				local term = ctx.item and ctx.item.item or nil
				local buf = term and term.buf
				if not (buf and vim.api.nvim_buf_is_valid(buf)) then
					ctx.preview:notify("Terminal closed", "warn")
					return
				end

				ctx.preview:set_title(terminal_label(term))
				ctx.preview:set_buf(buf)
				ctx.preview:loc()
			end,
			actions = {
				delete = function(picker, item)
					if not item or not item.item then
						return
					end

					local term = item.item
					local function reopen_if_needed()
						local remaining = Snacks.terminal.list()
						if #remaining > 0 then
							vim.schedule(function()
								pick_terminal_to_close()
							end)
						end
					end

					-- close the picker first to avoid window close/startinsert races
					if not picker.closed then
						picker:close()
					end

					vim.schedule(function()
						if term.buf and vim.api.nvim_buf_is_valid(term.buf) then
							local ok, err = pcall(term.close, term)
							if not ok then
								vim.notify(("Could not close terminal: %s"):format(err), vim.log.levels.ERROR, { title = "Terminals" })
								return
							end
						end
						reopen_if_needed()
					end)
				end,
			},
			win = {
				list = {
					keys = {
						d = "delete",
					},
				},
			},
		},
	}, function(choice)
		if not choice then
			return
		end

		local ok, err = pcall(choice.close, choice)
		if not ok then
			vim.notify(("Could not close terminal: %s"):format(err), vim.log.levels.ERROR, { title = "Terminals" })
		end
	end)
end

local function toggle_terminal(position, opts)
	opts = opts or {}
	local count = (opts.base or 0) + (vim.v.count > 0 and vim.v.count or 1)
	local merged = vim.tbl_deep_extend("force", {
		count = count,
		cwd = vim.fn.getcwd(-1, -1), -- keep a stable id even if window-local cwd changes
		win = {
			position = position,
			height = opts.height,
			width = opts.width,
			border = opts.border,
		},
	}, opts)

	return Snacks.terminal.toggle(nil, merged)
end

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
		dashboard = {
			enabled = true,
			preset = {
				header = [[
███╗   ██╗███████╗██████╗ ██████╗
████╗  ██║██╔════╝██╔══██╗██╔══██╗
██╔██╗ ██║█████╗  ██████╔╝██║  ██║
██║╚██╗██║██╔══╝  ██╔══██╗██║  ██║
██║ ╚████║███████╗██║  ██║██████╔╝
╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝╚═════╝
]],
			},
		},
		explorer = { enabled = true },
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
			interactive = false, -- stay in normal mode by default
			start_insert = false,
			auto_insert = false,
			shell = vim.fn.has("win32") == 1 and { "pwsh.exe", "-NoLogo" } or nil,
		},
		scratch = { enabled = false },
		animate = { enabled = true },
		bufdelete = { enabled = true },
		zen = { enabled = true },
		dim = { enabled = true },
		gitbrowse = { enabled = true },
		lazygit = {
			theme = {
				[241]                      = { fg = "Special" },
				activeBorderColor          = { fg = "LazyGitActiveBorder", bold = true },
				cherryPickedCommitBgColor  = { fg = "Identifier" },
				cherryPickedCommitFgColor  = { fg = "Function" },
				defaultFgColor             = { fg = "Normal" },
				inactiveBorderColor        = { fg = "FloatBorder" },
				optionsTextColor           = { fg = "Function" },
				searchingActiveBorderColor = { fg = "MatchParen", bold = true },
				selectedLineBgColor        = { bg = "Visual" }, -- set to `default` to have no background colour
				unstagedChangesColor       = { fg = "DiagnosticError" },
			},
		},
	},
	keys = {
		{
			"<A-h>",
			function()
				toggle_terminal("bottom")
			end,
			desc = "Toggle terminal",
			mode = "t",
		},
		{
			"<A-h>",
			function()
				toggle_terminal("bottom")
			end,
			desc = "Toggle terminal",
		},
			{
			"<A-v>",
			function()
				toggle_terminal("right", { base = 100, width = 0.3 })
			end,
			desc = "Terminal vertical split (use count for new)",
		},
		{
			"<A-f>",
			function()
				toggle_terminal("float", { base = 200, width = 0.9, height = 0.9, border = "rounded" })
			end,
			desc = "Terminal float (use count for new)",
		},
		{
			"<leader>tc",
			pick_terminal_to_close,
			desc = "Close terminal (pick buffer)",
		},

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
			desc = "Log"
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
			desc = "Branches"
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
			desc = "Log Line"
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
			desc = "Status"
		},
		{ "<leader>gS", function() Snacks.picker.git_stash() end,                 desc = "Stash" },
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
			desc = "Diff (Hunks)"
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
			desc = "Log File"
		},
		{ "<leader>ga", function() Snacks.lazygit() end,                          desc = "Lazy Git" },

		-- Github
		{ "<leader>gi", function() Snacks.picker.gh_issue() end,                  desc = "Issues (open)" },
		{ "<leader>gI", function() Snacks.picker.gh_issue({ state = "all" }) end, desc = "Issues (all)" },
		{ "<leader>gp", function() Snacks.picker.gh_pr() end,                     desc = "Pull Requests (open)" },
		{ "<leader>gP", function() Snacks.picker.gh_pr({ state = "all" }) end,    desc = "Pull Requests (all)" },
		{ "<leader>gB", function() Snacks.gitbrowse.open() end,                   desc = "Browser" },



		{
			"<leader>ff",
			function()
				Snacks.picker.files({
					layout = { preset = "ivy" },
				})
			end,
			desc = "Smart Find Files"
		},
		{
			"<C-b>",
			function()
				Snacks.picker.buffers({
					-- Focus the list so we don't auto-enter insert mode
					on_show = function()
						vim.cmd.stopinsert()
					end,
					layout = {
						preset = "sidebar",
						layout = {
							preview = "main",
							position = "right",
							width = buffer_sidebar_width,
							min_width = buffer_sidebar_width,
							max_width = buffer_sidebar_width,
						},
					},
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
		{ "<leader>fk", function() Snacks.picker.keymaps() end,         desc = "keymaps" },
		{ "<leader>fg", function() Snacks.picker.grep() end,            desc = "Grep" },
		{ "<leader>fh", function() Snacks.picker.command_history() end, desc = "Command History" },
		{ "<leader>fn", function() Snacks.picker.notifications() end,   desc = "Notification History" },
		{ "<leader>fu", function() user_secrets.open_picker() end,      desc = "User Secrets" },
		{ "<leader>fr", function() dotnet_runner.pick_and_run() end,    desc = ".NET run (pick project/profile)" },
		{
			"<leader>e",
			function()
				Snacks.explorer({ layout = { preset = "default", preview = true } })
			end,
			desc = "File Explorer (ivy)",
		},
		{
			"<C-e>",
			function()
				Snacks.explorer()
			end,
			desc = "File Explorer",
		},
		{ "<leader>fp", function() Snacks.picker.projects() end,              desc = "Projects" },

		{ "<leader>bd", function() Snacks.bufdelete() end,                    desc = "Delete current buffer" },

		-- LSP
		{ "gd",         function() Snacks.picker.lsp_definitions() end,       desc = "Goto Definition" },
		{ "gD",         function() Snacks.picker.lsp_declarations() end,      desc = "Goto Declaration" },
		{ "gr",         function() Snacks.picker.lsp_references() end,        nowait = true,                  desc = "References" },
		{ "gi",         function() Snacks.picker.lsp_implementations() end,   desc = "Goto Implementation" },
		{ "gy",         function() Snacks.picker.lsp_type_definitions() end,  desc = "Goto T[y]pe Definition" },
		{ "gaI",        function() Snacks.picker.lsp_incoming_calls() end,    desc = "C[a]lls Incoming" },
		{ "gao",        function() Snacks.picker.lsp_outgoing_calls() end,    desc = "C[a]lls Outgoing" },
		{ "<leader>ls", function() Snacks.picker.lsp_symbols() end,           desc = "LSP Symbols" },
		{ "<leader>lS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
		{ "<leader>ld", function() Snacks.picker.diagnostics() end,           desc = "Workspace Diagnostics" },
		{ "<leader>lD", function() Snacks.picker.diagnostics_buffer() end,    desc = "Buffer Diagnostics" },
		{
			"<Space>.",
			function()
				require("actions-preview").code_actions()
			end,
			desc = "Code action"
		},
		{ "<leader>lf", function() vim.lsp.buf.format({ async = true }) end, desc = "Format file" },

		{ "]]",         function() Snacks.words.jump(1, true) end,           desc = "Next Reference" },
		{ "[[",         function() Snacks.words.jump(-1, true) end,          desc = "Previous Reference" },
	},
}
