return {
	{
		name = "ravenwood-light-theme",
		dir = vim.fn.expand("~/.config/omarchy/themes/ravenwood-light"),
		lazy = false,
		priority = 1000,
		config = function()
			-- Load the custom Ravenwood Light colorscheme
			local ok, err = pcall(function()
				dofile(vim.fn.expand("~/.config/omarchy/themes/ravenwood-light/colors/ravenwood-light.lua"))
			end)
			
			if not ok then
				-- Fallback to catppuccin-latte if custom theme fails
				vim.notify("Ravenwood Light colorscheme not found, falling back to catppuccin-latte", vim.log.levels.WARN)
				vim.cmd.colorscheme("catppuccin-latte")
			end
		end,
	},
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "ravenwood-light",
		},
	},
}
