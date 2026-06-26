return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "prettier",
        "eslint-lsp",
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        eslint = {},
      },
    },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        typescript = { "deno_fmt", "prettier", stop_after_first = true },
        typescriptreact = { "deno_fmt", "prettier", stop_after_first = true },
        javascript = { "deno_fmt", "prettier", stop_after_first = true },
        javascriptreact = { "deno_fmt", "prettier", stop_after_first = true },
      },
      formatters = {
        deno_fmt = {
          -- deno.json(c) があるプロジェクトでのみ実行する
          condition = function(_, ctx)
            return require("lspconfig.util").root_pattern("deno.json", "deno.jsonc")(ctx.filename) ~= nil
          end,
        },
      },
    },
  },
}
