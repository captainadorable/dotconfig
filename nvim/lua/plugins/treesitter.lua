return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",

	defaults = {
	    lazy = false,
	    version = nil,
	    -- version = "*", -- enable this to try installing the latest stable versions of plugins
	},

	config = function () 
		local configs = require("nvim-treesitter.configs")

		configs.setup({
			ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "javascript", "html", "css", "go", "typescript" },
			sync_install = false,
			highlight = { enable = true },
			indent = { enable = true },  
		})
	end
}



