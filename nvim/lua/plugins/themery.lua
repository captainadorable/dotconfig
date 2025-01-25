return {
    "zaldih/themery.nvim",
    lazy = false,
    config = function()
        require("themery").setup({
            themes = {"tokyodark", "tokyonight", "catppuccin-frappe", "catppuccin-macchiato", "catppuccin-mocha", "rose-pine", "cyberdream"}, -- Your list of installed colorschemes.
            livePreview = true, -- Apply theme while picking. Default to true.
        })

        vim.keymap.set("n", "<leader>th", vim.cmd.Themery)

    end
}
