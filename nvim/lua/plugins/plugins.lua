return {
  "romainl/vim-cool",
  "tpope/vim-fugitive",
  {
    "nvim-lua/plenary.nvim",
    name = "plenary"
  },
  { "folke/tokyonight.nvim",         name = "tokyonight" },
  { "catppuccin/nvim",               name = "catppuccin" },
  { "rose-pine/neovim",              name = "rose-pine" },
  { "scottmckendry/cyberdream.nvim", name = "cyberdream" },
  {
    "tiagovla/tokyodark.nvim",
    opts = {
      -- transparent_background = true
    },
    config = function(_, opts)
      require("tokyodark").setup(opts)   -- calling setup is optional
    end,
  }
}
