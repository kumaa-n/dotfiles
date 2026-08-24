return {
  {
    "tpope/vim-rails",
  },

  {
    "tpope/vim-endwise",
  },

  {
    "slim-template/vim-slim",
    ft = { "slim" },
  },

  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "solargraph",
        "rubocop",
        "herb-language-server",
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        solargraph = {},
      },
    },
  },
}
