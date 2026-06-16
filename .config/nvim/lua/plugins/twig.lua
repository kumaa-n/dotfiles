return {
  {
    "lumiliet/vim-twig",
    ft = { "twig" },
    -- vim-twig's ftdetect sets *.twig / *.html.twig to the compound "html.twig"
    -- filetype. Convert it to plain "twig" so treesitter and
    -- twiggy_language_server (ft = "twig") attach. Registered via `init` so it
    -- runs at startup, before the initial buffers are read.
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "html.twig",
        callback = function()
          vim.bo.filetype = "twig"
        end,
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "twig",
      })
    end,
  },

  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "twiggy-language-server",
        "twig-cs-fixer",
      })
    end,
  },

  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.twig = { "twig-cs-fixer", "djhtml" }
      opts.formatters = opts.formatters or {}
      opts.formatters.djhtml = {
        command = "djhtml",
        args = { "-" },
        stdin = true,
      }
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        twiggy_language_server = {
          init_options = {
            framework = "symfony",
          },
        },
      },
    },
  },
}
