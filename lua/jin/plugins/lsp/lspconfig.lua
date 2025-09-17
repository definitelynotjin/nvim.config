return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = { ensure_installed = { "css", "html", "javascript", "typescript", "vue" } },
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "saghen/blink.cmp" },
			{ "folke/neodev.nvim", opts = {} },
		},
		config = function()
			local lspconfig = require("lspconfig")
			local keymap = vim.keymap
			local util = require("lspconfig.util")
			local function get_tsdk(root_dir)
				local ts = util.path.join(root_dir, "node_modules", "typescript", "lib")
				if vim.fn.isdirectory(ts) == 1 then
					return ts
				end
				return nil
			end

			-- shared on_attach
			local on_attach = function(_, bufnr)
				local opts = { buffer = bufnr, silent = true }
				keymap.set("n", "gR", vim.lsp.buf.references, opts)
				keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
				keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)
				keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
				keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=1<CR>", opts)
				keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
				keymap.set("n", "K", vim.lsp.buf.hover, opts)
				keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
			end

			-- capabilities
			local capabilities = require("blink.cmp").get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())

			-- diagnostics look
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

			-- main servers
			local servers = {}
			for _, lsp in ipairs(servers) do
				lspconfig[lsp].setup({
					on_attach = on_attach,
					capabilities = capabilities,
				})
			end

			lspconfig.clangd.setup({
				on_attach = on_attach,
				capabilities = capabilities,
			})

			local mason_packages = vim.fn.stdpath("data") .. "/mason/packages"
			local volar_path = mason_packages .. "/vue-language-server/node_modules/@vue/language-server"

			lspconfig.ts_ls.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				init_options = {
					plugins = {
						{
							name = "@vue/typescript-plugin",
							location = "/usr/local/lib/node_modules/@vue/language-server",
							languages = { "vue" },
						},
					},
				},
				settings = {
					typescript = {
						inlayHints = {
							includeInlayParameterNameHints = "all",
							includeInlayParameterNameHintsWhenArgumentMatchesName = true,
							includeInlayFunctionParameterTypeHints = true,
							includeInlayVariableTypeHints = true,
							includeInlayVariableTypeHintsWhenTypeMatchesName = true,
							includeInlayPropertyDeclarationTypeHints = true,
							includeInlayFunctionLikeReturnTypeHints = true,
							includeInlayEnumMemberValueHints = true,
						},
					},
				},
				filetypes = { "typescriptreact", "javascript", "typescriptreact", "javascriptreact", "vue" },
			})

			lspconfig.eslint.setup({
				cmd = { "eslint_d", "--stdin" },
				on_attach = function(client, bufnr)
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentRangeFormattingProvider = false
					on_attach(client, bufnr)
				end,
				capabilities = capabilities,
				root_dir = util.root_pattern(
					".eslintrc",
					".eslintrc.js",
					".eslintrc.json",
					"eslint.config.js",
					"package.json",
					".git"
				),
				filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
				single_file_support = false,
			})

			-- Volar (handles Vue + TS, no need for ts_ls)
			--
			--
			--
			local tsdk_path = get_tsdk(vim.loop.cwd())
			lspconfig.volar.setup({
				init_options = {
					vue = {
						hybridMode = false,
					},
				},
				settings = {
					typescript = {
						inlayHints = {
							enumMemberValues = {
								enabled = true,
							},
							functionLikeReturnTypes = {
								enabled = true,
							},
							propertyDeclarationTypes = {
								enabled = true,
							},
							parameterTypes = {
								enabled = true,
								suppressWhenArgumentMatchesName = true,
							},
							variableTypes = {
								enabled = true,
							},
						},
					},
				},
			})

			-- lspconfig.volar.setup({
			-- 	on_attach = on_attach,
			-- 	capabilities = capabilities,
			-- 	filetypes = { "vue" },
			-- 	init_options = {
			-- 		typescript = tsdk_path and { tsdk = tsdk_path } or nil,
			-- 		vue = {
			-- 			hybridMode = true,
			-- 			languageFeatures = { style = true, template = true, script = true },
			-- 		},
			-- 	},
			-- })
		end,
	},
}
