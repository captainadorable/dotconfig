return {
  "nvim-tree/nvim-tree.lua",
  config = function()
    -- disable netrw at the very start of your init.lua
    vim.keymap.set("n", "<C-n>", vim.cmd.NvimTreeToggle)

    -- OR setup with some options
    require("nvim-tree").setup({
      sort = {
        sorter = "case_sensitive",
      },
      view = {
        width = 30,
      },
      renderer = {
        group_empty = true,
      },
    })
  end
}
