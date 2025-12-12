local Snacks = require("snacks")

local M = {}

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

function M.pick_terminal_to_close()
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
								M.pick_terminal_to_close()
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
								vim.notify(("Could not close terminal: %s"):format(err), vim.log.levels.ERROR,
									{ title = "Terminals" })
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

function M.toggle(position, opts)
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

return M
