return {
  {
    "lumiliet/vim-twig",
    ft = { "twig" },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.filetype.add({
        pattern = {
          [".*%.html%.twig"] = "twig",
        },
      })
    end,
  },
}
