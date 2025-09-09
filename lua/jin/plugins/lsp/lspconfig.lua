return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = { ensure_installed = { "css" } },
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			{ "antosha417/nvim-lsp-file-operations", config = true },
			{ "folke/neodev.nvim", opts = {} },
		},
		config = function()
			local lspconfig = require("lspconfig")
			local cmp_nvim_lsp = require("cmp_nvim_lsp")
			local keymap = vim.keymap

			-- LSP attach keymaps
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					local opts = { buffer = ev.buf, silent = true }

					keymap.set("n", "gR", function()
						vim.lsp.buf.references({ position_encoding = "utf-16" })
					end, { desc = "Show LSP references", buffer = ev.buf })

					keymap.set("n", "gD", function()
						vim.lsp.buf.declaration({ position_encoding = "utf-16" })
					end, { desc = "Go to declaration", buffer = ev.buf })

					keymap.set("n", "gd", function()
						vim.lsp.buf.definition({ position_encoding = "utf-16" })
					end, { desc = "Go to definition", buffer = ev.buf })

					-- For other LSP calls that don't need position_encoding, keep them as-is
					keymap.set(
						"n",
						"gi",
						"<cmd>Telescope lsp_implementations<CR>",
						{ desc = "Go to implementation", buffer = ev.buf }
					)
					keymap.set(
						"n",
						"gt",
						"<cmd>Telescope lsp_type_definitions<CR>",
						{ desc = "Go to type definition", buffer = ev.buf }
					)
					keymap.set(
						{ "n", "v" },
						"<leader>ca",
						vim.lsp.buf.code_action,
						{ desc = "Code actions", buffer = ev.buf }
					)
					keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol", buffer = ev.buf })
					keymap.set(
						"n",
						"<leader>D",
						"<cmd>Telescope diagnostics bufnr=0<CR>",
						{ desc = "Buffer diagnostics", buffer = ev.buf }
					)
					keymap.set(
						"n",
						"<leader>d",
						vim.diagnostic.open_float,
						{ desc = "Line diagnostics", buffer = ev.buf }
					)
					keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic", buffer = ev.buf })
					keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic", buffer = ev.buf })
					keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation", buffer = ev.buf })
					keymap.set("n", "<leader>rs", ":LspRestart<CR>", { desc = "Restart LSP", buffer = ev.buf })
				end,
			})

			-- Enable autocompletion capabilities
			local capabilities = cmp_nvim_lsp.default_capabilities()

			-- Configure diagnostics signs
			vim.diagnostic.config({
				virtual_text = true,
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "",
						[vim.diagnostic.severity.WARN] = "",
						[vim.diagnostic.severity.HINT] = "󰠠",
						[vim.diagnostic.severity.INFO] = "",
					},
				},
				underline = true,
				update_in_insert = false,
			})

			-- Setup LSP servers
			local servers = {
				tailwindcss = {},
				emmet_ls = {
					filetypes = {
						"html",
						"typescriptreact",
						"javascriptreact",
						"css",
						"sass",
						"scss",
						"less",
					},
				},
				lua_ls = {
					settings = {
						Lua = {
							diagnostics = { globals = { "vim" } },
							completion = { callSnippet = "Replace" },
						},
					},
				},
			}
			-- TypeScript LS with Vue plugin
			lspconfig.ts_ls.setup({
				filetypes = {
					"typescript",
					"javascript",
					"javascriptreact",
					"typescriptreact",
				},
				capabilities = capabilities,
			})

			-- Volar (handles template + CSS inside .vue files)
			lspconfig.volar.setup({
				filetypes = { "vue" },
				init_options = {
					vue = {
						hybridMode = true,
						languageFeatures = {
							style = true,
						},
					},
					typescript = {
						tsdk = vim.fn.getcwd() .. "/node_modules/typescript/lib",
					},
				},
				capabilities = capabilities,
			})

			lspconfig.eslint.setup({
				filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
				settings = {},
				root_dir = lspconfig.util.root_pattern(
					".eslintrc.js",
					".eslintrc.json",
					".eslintrc.yaml",
					"package.json"
				),
				capabilities = capabilities,
			})

			-- Loop through other servers
			for server, opts in pairs(servers) do
				opts.capabilities = capabilities
				lspconfig[server].setup(opts)
			end
		end,
	},
}
