return {
  {
    "Jezda1337/nvim-html-css",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      enable_on = {
        "html",
        "twig",
        "php",
        "blade",
        "erb",
        "slim",
        "javascriptreact",
        "typescriptreact",
        "vue",
      },
      style_sheets = {
        "https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css",
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "css",
      })
    end,
  },
}
