return {
  "neovim/nvim-lspconfig",
  dependencies = {
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/nvim-cmp" },
    { "williamboman/mason.nvim",          cmd = "Mason" },
    { "williamboman/mason-lspconfig.nvim" },
    {
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      config = true
      -- use opts = {} for passing setup options
      -- this is equivalent to setup({}) function
    },
    {
      "L3MON4D3/LuaSnip",
      -- follow latest release.
      version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
      -- install jsregexp (optional!).
      build = "make install_jsregexp",
      dependencies = { "rafamadriz/friendly-snippets" }
    },
    { "saadparwaiz1/cmp_luasnip" }
  },
  defaults = {
    lazy = false
  },
  config = function()
    -- Reserve a space in the gutter
    vim.opt.signcolumn = "yes"

    -- Add cmp_nvim_lsp capabilities settings to lspconfig
    -- This should be executed before you configure any language server
    local lspconfig_defaults = require("lspconfig").util.default_config
    lspconfig_defaults.capabilities =
        vim.tbl_deep_extend(
          "force",
          lspconfig_defaults.capabilities,
          require("cmp_nvim_lsp").default_capabilities()
        )

    require("lspconfig").gdscript.setup(lspconfig_defaults)
    -- This is where you enable features that only work
    -- if there is a language server active in the file
    vim.api.nvim_create_autocmd(
      "LspAttach",
      {
        desc = "LSP actions",
        callback = function(event)
          local opts = { buffer = event.buf }

          vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
          vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
          vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
          vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
          vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
          vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
          vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
          vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
          vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
          vim.keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
        end
      }
    )

    require("mason").setup({})
    require("mason-lspconfig").setup(
      {
        -- Replace the language servers listed here
        -- with the ones you want to install
        ensure_installed = { "lua_ls", "gopls" },
        handlers = {
          function(server_name)
            require("lspconfig")[server_name].setup({})
          end,
          ["lua_ls"] = function()
            local lspconfig = require("lspconfig")
            lspconfig.lua_ls.setup {
              settings = {
                Lua = {
                  runtime = { version = "Lua 5.1" },
                  diagnostics = {
                    globals = { "bit", "vim", "it", "describe", "before_each", "after_each" }
                  }
                }
              }
            }
          end,
          gopls = function()
            local lspconfig = require("lspconfig")
            local util = require "lspconfig/util"

            lspconfig.gopls.setup {
              cmd = { "gopls" },
              filetypes = { "go", "gomod", "gowork", "gotmpl" },
              root_dir = util.root_pattern("go.work", "go.mod", ".git"),
              settings = {
                gopls = {
                  completeUnimported = true,
                  usePlaceholders = true,
                  analyses = {
                    unusedparams = true,
                    bools = true,
                    deprecated = true,
                    modernize = true,
                    unreachable = true,
                  },
                },
              },
            }
          end
        }
      }
    )

    local cmp = require("cmp")
    require("luasnip.loaders.from_vscode").lazy_load()
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

    cmp.setup(
      {
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" }
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ['<CR>'] = cmp.mapping.confirm({ select = false }),
          -- Super tab
          ['<Tab>'] = cmp.mapping(function(fallback)
            local luasnip = require('luasnip')
            local col = vim.fn.col('.') - 1

            if cmp.visible() then
              cmp.select_next_item({ behavior = 'select' })
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
              fallback()
            else
              cmp.complete()
            end
          end, { 'i', 's' }),

          -- Super shift tab
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            local luasnip = require('luasnip')

            if cmp.visible() then
              cmp.select_prev_item({ behavior = 'select' })
            elseif luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        })
      }
    )
  end
}
