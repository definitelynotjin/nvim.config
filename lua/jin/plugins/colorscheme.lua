return {
	"navarasu/onedark.nvim",
	priority = 1000,
	config = function()
		require("onedark").setup({
			style = "darker",
			transparent = true,
			term_colors = true,
			lualine = { transparent = true },
			bufferline = { transparent = true },
			diagnostics = {
				darker = true,
				undercurl = true,
				background = true,
			},
		})
		require("onedark").load()

		local c = require("onedark.colors")

		-- Standard floating windows
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = c.bg })
		vim.api.nvim_set_hl(0, "FloatBorder", { bg = c.bg })
		-- No x
		vim.api.nvim_set_option("tabline", [[%{%v:lua.require("tabline").draw()%}]])

		-- Transparent statusline
		vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE" })
		vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE" })

		-- Transparent bufferline
		vim.api.nvim_set_hl(0, "BufferLineBackground", { bg = "NONE" })
		vim.api.nvim_set_hl(0, "BufferLineFill", { bg = "NONE" })
		vim.api.nvim_set_hl(0, "BufferLineSeparator", { bg = c.bg })
		vim.api.nvim_set_hl(0, "BufferLineSeparatorSelected", { bg = c.bg })
		vim.api.nvim_set_hl(0, "BufferLineBackground", { bg = c.bg })
		vim.api.nvim_set_hl(0, "BufferLineFill", { bg = c.bg })
		vim.api.nvim_set_hl(0, "TabLineFill", { bg = c.bg })
		vim.api.nvim_set_hl(0, "TabLine", { bg = c.bg })
		vim.api.nvim_set_hl(0, "ColorColumn", { bg = c.bg })

		-- Popup menu (completion menu)
		vim.api.nvim_set_hl(0, "Pmenu", { bg = c.bg, blend = 0 })
		vim.api.nvim_set_hl(0, "CmpNormal", { bg = c.bg, blend = 0 })
		vim.api.nvim_set_hl(0, "CmpDocNormal", { bg = c.bg, blend = 0 })

		-- Ensure Neovim options remove extra transparency
		vim.opt.pumblend = 0 -- completion menu
		vim.opt.winblend = 0 -- floating windows

		-- Configure nvim-cmp to use these highlights
		local cmp = require("cmp")
		cmp.setup({
			window = {
				completion = {
					border = "rounded",
					winhighlight = "Normal:CmpNormal",
				},
				documentation = {
					border = "rounded",
					winhighlight = "Normal:CmpDocNormal",
				},
			},
		})
	end,
}
