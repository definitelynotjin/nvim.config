return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	config = function()
		-- import nvim-treesitter plugin
		local treesitter = require("nvim-treesitter.configs")

		-- configure treesitter
		treesitter.setup({
			auto_install = true,
			sync_install = false,
			ignore_install = {},
			highlight = {
				enable = true,
			},
			-- enable indentation
			indent = { enable = true },
			-- ensure these language parsers are installed
			ensure_installed = {
				"json",
				"javascript",
				"typescript",
				"tsx",
				"yaml",
				"html",
				"css",
				"markdown",
				"markdown_inline",
				"bash",
				-- "lua",
				"vim",
				"dockerfile",
				"gitignore",
				"query",
				"vimdoc",
				"vue",
				"c",
			},
		})

		-- use bash parser for zsh files
		vim.treesitter.language.register("bash", "zsh")
	end,
}
