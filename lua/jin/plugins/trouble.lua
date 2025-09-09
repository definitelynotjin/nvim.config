return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	cmd = "Trouble",
	keys = {

		{ "<leader>xx", ":Trouble diagnostics toggle<CR>", desc = "Toggle trouble diagnostics" },

		{ "<leader>xd", ":Trouble diagnostics toggle filter.buf=0<CR>", desc = "Togle trouble document diagnostics" },

		{ "<leader>xq", ":Trouble quickfix toggle<CR>", desc = "Toggle trouble quickfix list" },

		{ "<leader>xl", ":Trouble loclist toggle<CR>", desc = "Toggle trouble location list" },

		{ "<leader>xt", ":Trouble todo toggle<CR>", desc = "Toggle trouble todos list" },
	},

	opts = {}, -- use default config
}
