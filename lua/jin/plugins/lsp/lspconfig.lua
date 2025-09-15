return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = { ensure_installed = { "css" } },
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

			-- Define on_attach once
			local on_attach = function(client, bufnr)
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

			-- Enable autocompletion capabilities
			local capabilities = require("blink.cmp").get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())

			-- Configure diagnostics
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

			-- Setup servers
			local servers = {
				tailwindcss = {},
				emmet_ls = { filetypes = { "javascript", "typescript", "html", "vue", "css" } },
				lua_ls = { settings = { Lua = { diagnostics = { globals = { "vim" } } } } },
			}

			-- Loop through servers
			for server, opts in pairs(servers) do
				opts.on_attach = on_attach
				opts.capabilities = capabilities
				lspconfig[server].setup(opts)
			end

			-- TypeScript with Vue plugin
			local global_ts_plugin =
				vim.fn.expand("~/.nvm/versions/node/v21.19.4/lib/node_modules/@vue/typescript-plugin")
			lspconfig.ts_ls.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				init_options = {
					plugins = {
						{ name = "@vue/typescript-plugin", location = global_ts_plugin, language = { "vue" } },
					},
				},
				filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
			})

			-- Volar
			lspconfig.volar.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				filetypes = { "vue", "typescript", "javascript", "typescriptreact", "javascriptreact", "json" },
				init_options = {
					vue = { hybridMode = true, languageFeatures = { style = true, template = true, script = true } },
					typescript = { tsdk = vim.fn.getcwd() .. "/node_modules/typescript/lib" },
				},
			})
		end,
	},
}
