return {
	"folke/lazydev.nvim",
	config = function()
		require("lazydev").setup({
			library = { "nvim-dap-ui" },
		})
	end,
}
