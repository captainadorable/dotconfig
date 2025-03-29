return {
  "neovim/nvim-lspconfig",
  dependencies = {
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/nvim-cmp" },
    { "williamboman/mason.nvim",          cmd = "Mason" },
    { "williamboman/mason-lspconfig.nvim" },
    {
      "L3MON4D3/LuaSnip",
      -- follow latest release.
      version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
      lazy = false,
      -- install jsregexp (optional!).
      build = "make install_jsregexp",
      dependencies = { "rafamadriz/friendly-snippets" }
    },
    { "saadparwaiz1/cmp_luasnip" },
    {
      "zbirenbaum/copilot.lua",
      config = function()
        require("copilot").setup({
          panel = {
            enabled = true,
            auto_refresh = false,
            keymap = {
              jump_prev = "[[",
              jump_next = "]]",
              accept = "<CR>",
              refresh = "gr",
              open = "<M-CR>"
            },
            layout = {
              position = "right", -- | top | left | right | horizontal | vertical
              ratio = 0.4
            },
          },
          suggestion = {
            enabled = true,
            auto_trigger = false,
            hide_during_completion = true,
            debounce = 75,
            keymap = {
              accept = "<M-l>",
              accept_word = false,
              accept_line = false,
              next = "<M-]>",
              prev = "<M-[>",
              dismiss = "<C-]>",
            },
          },
          filetypes = {
            yaml = false,
            markdown = false,
            help = false,
            gitcommit = false,
            gitrebase = false,
            hgcommit = false,
            svn = false,
            cvs = false,
            ["."] = false,
          },
          copilot_node_command = 'node', -- Node.js version must be > 18.x
          server_opts_overrides = {},
        })
      end
    },
    -- {
    --   "zbirenbaum/copilot-cmp",
    --   config = function()
    --     require("copilot_cmp").setup()
    --   end
    -- }
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

    local lspconfig = require("lspconfig")
    lspconfig.gdscript.setup(lspconfig_defaults)

    local MY_FQBN = "arduino:avr:nano"
    lspconfig.arduino_language_server.setup {
      cmd = {
        ".local/share/nvim/mason/bin/arduino-language-server",
        "-clangd", "/home/captainadorable/.local/share/nvim/mason/bin/clangd",
        "-cli", "/usr/bin/arduino-cli",
        "-cli-config", "/home/captainadorable/.arduino15/arduino-cli.yaml",
        "-fqbn", MY_FQBN
      }
    }

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
          vim.keymap.set("n", "<leader>e", ':lua vim.diagnostic.open_float(0, {scope="line"}) <ENTER>')
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


    cmp.setup(
      {
        sources = {
          { name = "copilot" },
          { name = "nvim_lsp" },
          { name = "luasnip" }
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end
        },
        window = {
          documentation = cmp.config.window.bordered(),
          completion = cmp.config.window.bordered()
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
    require("copilot").setup({
      suggestion = { enabled = false },
      panel = { enabled = false },
    })
  end
}
