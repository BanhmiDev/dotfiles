return({
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"jay-babu/mason-nvim-dap.nvim",
	},
	config = function()
		require("mason").setup()
		require("mason-nvim-dap").setup()
		require("mason-lspconfig").setup()

		vim.lsp.enable("lua_ls")
		vim.lsp.enable("omnisharp")
		vim.lsp.enable("ols")
		vim.lsp.enable("zls")
		vim.lsp.enable("clangd")
		vim.lsp.enable("jsonls")
		vim.lsp.enable("ts_ls")
		vim.lsp.enable("html")
		vim.lsp.enable("rust_analyzer")
		vim.lsp.enable("jdtls")
		vim.lsp.enable("eslint")

		local capabilities = require("cmp_nvim_lsp").default_capabilities()
		vim.lsp.config("*", {
			capabilities = capabilities,
		})

		-- Use LspAttach autocommand to only map the following keys
		-- after the language server attaches to the current buffer
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				local map = function(keys, func, desc)
					vim.keymap.set("n", keys, func, { buffer = ev.buf, desc = "Lsp: " .. desc })
				end

				map("<leader>fd", vim.lsp.buf.definition, "Goto Definition")
				map("<leader>fs", vim.lsp.buf.document_symbol, "Document Symbols")
				map("<leader>fS", vim.lsp.buf.workspace_symbol, "Workspace Symbols")
				map("<leader>ft", vim.lsp.buf.type_definition, "Goto Type Definition")
				map("<leader>fr", vim.lsp.buf.references, "Goto References")
				map("<leader>fi", vim.lsp.buf.implementation, "Goto Implementation")

				map("K", vim.lsp.buf.hover, "hover")
				map("<leader>E", vim.diagnostic.open_float, "diagnostic")
				map("<leader>k", vim.lsp.buf.signature_help, "sig help")
				map("<leader>rn", vim.lsp.buf.rename, "rename")
				map("<leader>ca", vim.lsp.buf.code_action, "code action")
				map("<leader>wf", vim.lsp.buf.format, "format")

				vim.keymap.set(
					"v",
					"<leader>ca",
					vim.lsp.buf.code_action,
					{ buffer = ev.buf, desc = "Lsp: code_action" }
				)
			end,
		})

		require("mason-nvim-dap").setup({
			ensure_installed = { "cppdbg" },
			automatic_installation = true,
			handlers = {
				function(config)
					require("mason-nvim-dap").default_setup(config)
				end,
			},
		})

		local dap = require("dap")
		require("dapui").setup()

		dap.configurations.cpp = {
			{
				name = "Launch file",
				type = "cppdbg",
				request = "launch",
				program = function()
					return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
				end,
				cwd = "${workspaceFolder}",
				stopAtEntry = true,
			},
			{
				name = "Attach to gdbserver :1234",
				type = "cppdbg",
				request = "launch",
				MIMode = "gdb",
				miDebuggerServerAddress = "localhost:1234",
				miDebuggerPath = "/usr/bin/gdb",
				cwd = "${workspaceFolder}",
				program = function()
					return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
				end,
			},
		}
	end,
})
