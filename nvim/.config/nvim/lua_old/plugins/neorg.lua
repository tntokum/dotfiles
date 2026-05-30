return {
	"nvim-neorg/neorg",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		version = "v0.9.2",
	},
	lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
	version = "*", -- Pin Neorg to the latest stable release
	config = function()
		require("neorg").setup({
			load = {
				["core.defaults"] = {},
				["core.concealer"] = {},
				["core.dirman"] = {
					config = {
						workspaces = {
							notes = "~/Documents/notes",
							cuda = "~/Documents/code/cuda",
						},
						index = "index.norg",
						default_workspace = "notes",
					},
				},
			},
		})

		vim.wo.foldlevel = 99
		vim.wo.conceallevel = 3
	end,
}
