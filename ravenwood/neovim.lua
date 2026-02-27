return {
	{
		name = "ravenwood-theme",
		dir = vim.fn.expand("~/.config/omarchy/themes/ravenwood"),
		lazy = false,
		priority = 1000,
		config = function()
			-- Load the custom Ravenwood colorscheme
			local ok, err = pcall(function()
				dofile(vim.fn.expand("~/.config/omarchy/themes/ravenwood/colors/ravenwood.lua"))
			end)
			
			if not ok then
				-- Fallback to everforest if custom theme fails
				vim.notify("Ravenwood colorscheme not found, falling back to everforest", vim.log.levels.WARN)
				vim.cmd.colorscheme("everforest")
			end
		end,
	},
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "ravenwood",
		},
	},
}
