return {
  "romainl/vim-cool",
  "tpope/vim-fugitive",
  "airblade/vim-gitgutter",
  {
    "nvim-lua/plenary.nvim",
    name = "plenary"
  },
  {
    "folke/tokyonight.nvim",
    name = "tokyonight",
    opts = {
      transparent = true,
    }
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    config = function(_, opts)
      require("rose-pine").setup({
        styles = {
          bold = true,
          italic = true,
          transparency = true,
        },
        variant = "moon",  -- auto, main, moon, or dawn
        dark_variant = "main", -- main, moon, or dawn
        dim_inactive_windows = false,
        extend_background_behind_borders = true,
      })
    end,
  },
  { "scottmckendry/cyberdream.nvim", name = "cyberdream" },
  {
    "tiagovla/tokyodark.nvim",
    opts = {
      transparent_background = true
    },
    config = function(_, opts)
      require("tokyodark").setup(opts) -- calling setup is optional
    end,
  }
}
