return {
	"folke/flash.nvim",
	keys = {
		-- Override the default "s" keymap to search the whole buffer
		{
			"s",
			mode = { "n", "x", "o" },
			function()
				require("flash").jump({
					search = { mode = "search", max_length = 0 },
					label = { after = { 0, 0 } },
				})
			end,
			desc = "Flash",
		},
	},
}
