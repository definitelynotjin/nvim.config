return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local lualine = require("lualine")
		local lazy_status = require("lazy.status") -- to configure lazy pending updates count
		local colors = {
			blue = "#4591CF",
			green = "#8EBD6B",
			violet = "#BF68D9",
			yellow = "#FFDA7B",
			red = "#FF4A4A",
			fg = "#c3ccdc",
			bg = "#112638",
			inactive_bg = "#2c3043",
		}

		local my_lualine_theme = {
			normal = {
				a = { bg = "NONE", fg = colors.blue, gui = "bold" },
				b = { bg = "NONE", fg = colors.fg }, -- fully transparent
				c = { bg = "NONE", fg = colors.fg }, -- fully transparent
			},
			insert = {
				a = { bg = "NONE", fg = colors.green, gui = "bold" },
				b = { bg = "NONE", fg = colors.fg },
				c = { bg = "NONE", fg = colors.fg },
			},
			visual = {
				a = { bg = "NONE", fg = colors.violet, gui = "bold" },
				b = { bg = "NONE", fg = colors.fg },
				c = { bg = "NONE", fg = colors.fg },
			},
			command = {
				a = { bg = "NONE", fg = colors.yellow, gui = "bold" },
				b = { bg = "NONE", fg = colors.fg },
				c = { bg = "NONE", fg = colors.fg },
			},
			replace = {
				a = { bg = "NONE", fg = colors.red, gui = "bold" },
				b = { bg = "NONE", fg = colors.fg },
				c = { bg = "NONE", fg = colors.fg },
			},
			inactive = {
				a = { bg = "NONE", fg = colors.inactive_bg, gui = "bold" },
				b = { bg = "NONE", fg = colors.fg },
				c = { bg = "NONE", fg = colors.fg },
			},
		}

		-- configure lualine with modified theme
		lualine.setup({
			options = {
				theme = my_lualine_theme,
				section_separators = "",
				component_separators = "",
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = {},
				lualine_c = {
					{
						"filename",
						file_status = true,
						newfile_status = false,
						path = 1,
					},
				},
				lualine_x = {
					{
						lazy_status.updates,
						cond = lazy_status.has_updates,
						color = { fg = "#ff9e64" },
					},
				},
				lualine_y = { "diagnostics" },
				lualine_z = { "location" },
			},
		})
	end,
}
