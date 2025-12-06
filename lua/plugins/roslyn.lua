-- Roslyn / Razor tooling integration for .NET development
return {
	"seblyng/roslyn.nvim",
	---@module 'roslyn.config'
	---@type RoslynNvimConfig
	ft = { "cs", "razor" },
	opts = {
		-- your configuration comes here; leave empty for default settings
	},

	-- ADD THIS:

	dependencies = {
		{
			-- By loading as a dependencies, we ensure that we are available to set
			-- the handlers for Roslyn.
			"tris203/rzls.nvim",
			config = true,
		},
	},
	lazy = false,
	config = function()
		-- Use one of the methods in the Integration section to compose the command.
		local mason_registry = require("mason-registry")

		local rzls_path = vim.fn.expand("$MASON/packages/rzls/libexec")
		local cmd = {
			"roslyn",
			"--stdio",
			"--logLevel=Information",
			"--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
			"--razorSourceGenerator=" .. vim.fs.joinpath(rzls_path, "Microsoft.CodeAnalysis.Razor.Compiler.dll"),
			"--razorDesignTimePath=" .. vim.fs.joinpath(rzls_path, "Targets", "Microsoft.NET.Sdk.Razor.DesignTime.targets"),
			"--extension",
			vim.fs.joinpath(rzls_path, "RazorExtension", "Microsoft.VisualStudioCode.RazorExtension.dll"),
		}

		vim.lsp.config("roslyn", {
			cmd = cmd,
			handlers = require("rzls.roslyn_handlers"),

			settings = {

				-- ============================
				--     C# Inlay Hint Settings
				-- ============================
				["csharp|inlay_hints"] = {

					-- ❌ Disable non-parameter hints
					csharp_enable_inlay_hints_for_implicit_object_creation                = false,
					csharp_enable_inlay_hints_for_implicit_variable_types                 = false,
					csharp_enable_inlay_hints_for_lambda_parameter_types                  = false,
					csharp_enable_inlay_hints_for_types                                   = false,

					-- ✅ Enable parameter-only hints
					dotnet_enable_inlay_hints_for_parameters                              = true,
					dotnet_enable_inlay_hints_for_indexer_parameters                      = true,
					dotnet_enable_inlay_hints_for_literal_parameters                      = true,
					dotnet_enable_inlay_hints_for_object_creation_parameters              = true,
					dotnet_enable_inlay_hints_for_other_parameters                        = true,

					-- 🎯 Smart suppression (choose how minimal you want it)
					dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
					dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name   = true,
					dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent   = true,
				},

				-- ============================
				--     C# CodeLens Settings
				-- ============================
				["csharp|code_lens"] = {
					dotnet_enable_references_code_lens = true,
				},
			},
		})
		vim.lsp.enable("roslyn")
	end,
	init = function()
		-- We add the Razor file types before the plugin loads.
		vim.filetype.add({
			extension = {
				razor = "razor",
				cshtml = "razor",
			},
		})
	end,
}
