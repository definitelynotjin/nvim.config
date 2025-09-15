return {
	"folke/snacks.nvim",
	lazy = false,
	priority = 1000,
	opts = {
		indent = { enabled = true },
		picker = {
			enabled = true,
		},
		notifier = {
			enabled = true,
			timeout = 3000,
		},
		scroll = { enabled = true },
		styles = {
			notification = {
				{ wrap = true },
			},
		},
	},
}
