return {
	"andweeb/presence.nvim",
	config = function()
		require("presence").setup({
			auto_update = true,
			neovim_image_text = "Neovim",
			main_image = "file", -- Can be 'neovim' or 'file'
			log_level = nil,
			show_timer = false,
			debounce_timeout = 10,
			enable_line_number = true,
		})
	end,
}
