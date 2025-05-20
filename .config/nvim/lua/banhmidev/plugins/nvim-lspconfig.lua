return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"Hoffs/omnisharp-extended-lsp.nvim",
		"Issafalcon/lsp-overloads.nvim",
		"williamboman/mason.nvim",
		"L3MON4D3/LuaSnip",
	},
	config = function()
		local keymap = vim.keymap -- for conciseness

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				-- Buffer local mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local opts = { buffer = ev.buf, silent = true }

				-- set keybinds
				-- opts.desc = "Show LSP references"
				-- keymap.set("n", "<leader>gr", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

				-- opts.desc = "Go to declaration"
				-- keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

				-- opts.desc = "Show LSP definitions"
				-- keymap.set("n", "<leader>gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions
				--
				-- opts.desc = "Show LSP implementations"
				-- keymap.set("n", "<leader>gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations
				--
				-- opts.desc = "Show LSP type definitions"
				-- keymap.set("n", "<leader>gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

				opts.desc = "See available code actions"
				keymap.set("n", "<leader>ga", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

				opts.desc = "Smart rename"
				keymap.set("n", "<leader>gn", vim.lsp.buf.rename, opts) -- smart rename

				-- opts.desc = "Show buffer diagnostics"
				-- keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

				opts.desc = "Show line diagnostics"
				keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

				opts.desc = "Go to previous diagnostic"
				keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

				opts.desc = "Go to next diagnostic"
				keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

				opts.desc = "Show documentation for what is under cursor"
				keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

				opts.desc = "Restart LSP"
				keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
			end,
		})

		local capabilities = require("blink.cmp").get_lsp_capabilities()

		require("mason").setup({
			ensure_installed = {
				"phpactor",
				"omnisharp",
				"ts_ls",
				"eslint",
				"tailwindcss",
				"graphql",
			},
		})
		local lspconfig = require("lspconfig")

		--lspconfig.lua_ls.setup({
		--	capabilities = capabilities,
		--	handlers = rounded_borders,
		--})

		-- PHP (do not judge)
		lspconfig.phpactor.setup({
			cmd = { "phpactor", "language-server" },
			capabilities = capabilities,
			root_dir = lspconfig.util.root_pattern("composer.json"),
		})

		-- C#
		local omnisharp_bin = "/home/banhmi/.config/nvim/omnisharp-roslyn/OmniSharp.dll"
		lspconfig.omnisharp.setup({
			cmd = { "dotnet", omnisharp_bin },
			capabilities = capabilities,
			root_dir = function(fname)
				local primary = lspconfig.util.root_pattern("*.sln")(fname)
				local fallback = lspconfig.util.root_pattern("*.csproj")(fname)
				return primary or fallback
			end,
			settings = {
				FormattingOptions = {
					OrganizeImports = true,
				},
				RoslynExtensionsOptions = {
					AnalyzeOpenDocumentsOnly = true,
					EnableImportCompletion = true,
					EnableDecompilationSupport = true,
				},
				Sdk = {
					IncludePrereleases = true,
				},
			},
			--handlers = vim.tbl_extend("force", rounded_borders, {
			--	["textDocument/definition"] = require("omnisharp_extended").definition_handler,
			--	["textDocument/typeDefinition"] = require("omnisharp_extended").type_definition_handler,
			--	["textDocument/references"] = require("omnisharp_extended").references_handler,
			--	["textDocument/implementation"] = require("omnisharp_extended").implementation_handler,
			--}),
		})

		-- TypeScript/JavaScript
		lspconfig.ts_ls.setup({
			capabilities = capabilities,
			on_attach = function(client, bufnr)
				client.server_capabilities.documentFormattingProvider = false -- Use null-ls for formatting
			end,
		})

		-- ESLint
		lspconfig.eslint.setup({
			capabilities = capabilities,
			on_attach = function(client, bufnr)
				vim.api.nvim_create_autocmd("BufWritePre", {
					buffer = bufnr,
					command = "EslintFixAll",
				})
			end,
		})

		-- Tailwind CSS
		lspconfig.tailwindcss.setup({})

		-- GraphQL (optional)
		lspconfig.graphql.setup({})
	end,
}
