return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local transform_mod = require("telescope.actions.mt").transform_mod
		local trouble = require("trouble")
		local trouble_telescope = require("trouble.sources.telescope")

		-- 🔧 Hotfix deprecated LSP APIs
		do
			-- Patch jump_to_location → prefer show_document
			if vim.lsp.util and vim.lsp.util.jump_to_location then
				local old_jump = vim.lsp.util.jump_to_location
				vim.lsp.util.jump_to_location = function(location, ...)
					if vim.lsp.util.show_document then
						return vim.lsp.util.show_document(location, ...)
					end
					return old_jump(location, ...)
				end
			end

			-- Patch Telescope’s LSP client check (dot → colon)
			local ok, lsp_handlers = pcall(require, "telescope.builtin._internal")
			if ok and lsp_handlers.lsp_request then
				local orig = lsp_handlers.lsp_request
				lsp_handlers.lsp_request = function(bufnr, method, ...)
					local clients = vim.lsp.get_clients({ bufnr = bufnr })
					for _, client in ipairs(clients) do
						if client.supports_method and client:supports_method(method) then
							return orig(bufnr, method, ...)
						end
					end
				end
			end
		end
		-- 🔧 End hotfix

		-- Custom action
		local custom_actions = transform_mod({
			open_trouble_qflist = function(prompt_bufnr)
				trouble.toggle("quickfix")
			end,
		})

		telescope.setup({
			defaults = {
				path_display = { "smart" },
				mappings = {
					i = {
						["<C-j>"] = actions.move_selection_previous,
						["<C-k>"] = actions.move_selection_next,
						["<C-q>"] = actions.send_selected_to_qflist + custom_actions.open_trouble_qflist,
						["<C-t>"] = trouble_telescope.open,
						["<CR>"] = actions.select_tab,
					},
					n = {
						["<CR>"] = actions.select_tab,
					},
				},
			},
		})

		telescope.load_extension("fzf")

		-- Keymaps
		local keymap = vim.keymap
		keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
		keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
		keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
		keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
		keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
		keymap.set("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", { desc = "Find keymaps" })

		-- Auto-open Telescope on startup if no files provided
		vim.api.nvim_create_autocmd("VimEnter", {
			callback = function()
				if vim.fn.argc() == 0 then
					local ok, builtin = pcall(require, "telescope.builtin")
					if ok then
						-- close the empty buffer first
						if vim.bo.buftype == "" and vim.fn.bufname() == "" then
							vim.cmd("bd!") -- delete the no-name buffer
						end
						builtin.find_files({ prompt_title = "~ Start ~" })
					else
						local alpha = require("alpha")
						local dashboard = require("alpha.themes.dashboard")
						alpha.setup(dashboard.opts)
					end
				end
			end,
		})
	end,
}
