return {
	"stevearc/conform.nvim",
	event = { "VeryLazy" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>FF",
			function()
				require("conform").format({ async = true })
			end,
			mode = "n",
			desc = "Format buffer",
		},
	},
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "isort", "black" },
			javascript = { { "prettierd", "prettier" } },
			typescript = { { "prettierd", "prettier" } },
			vue = { "prettierd", "prettier" },
		},
		default_format_opts = {
			lsp_format = "never",
		},
		format_on_save = {
			pattern = "*",
			async = true,
		},
		formatters = {
			shfmt = {
				append_args = { "-i", "3" },
			},
		},
	},
	init = function()
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
}
