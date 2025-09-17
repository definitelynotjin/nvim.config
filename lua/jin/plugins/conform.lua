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
			javascript = { "eslint_d", "prettierd", "prettier" },
			typescript = { "eslint_d", "prettierd", "prettier" },
			vue = { "prettierd", "prettier" },
			json = { "eslint_d", "prettierd", "prettier" },
		},
		default_format_opts = {
			lsp_format = "never",
			stop_after_first = true,
		},
		format_on_save = {
			pattern = "*",
			lsp_format = "never",
			timeout_ms = 3000,
		},
		formatters = {
			eslint_d = {
				-- command = "eslint_d",
				-- args = { "--fix-to-stdout", "--stdin", "--stdin-filename", "$FILENAME" },
				-- stdin = true,
			},
			shfmt = {
				append_args = { "-i", "3" },
			},
		},
	},
	init = function()
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
}
