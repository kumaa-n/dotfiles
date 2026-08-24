return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "prettier",
        "eslint-lsp",
        "biome",
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local root_pattern = require("lspconfig.util").root_pattern

      opts.servers = vim.tbl_deep_extend("force", opts.servers or {}, {
        eslint = {
          root_dir = function(bufnr, on_dir)
            local fname = vim.api.nvim_buf_get_name(bufnr)
            if root_pattern("deno.json", "deno.jsonc")(fname) ~= nil then
              return
            end
            local dir = root_pattern(
              ".eslintrc",
              ".eslintrc.js",
              ".eslintrc.cjs",
              ".eslintrc.yaml",
              ".eslintrc.yml",
              ".eslintrc.json",
              "eslint.config.js",
              "eslint.config.mjs",
              "eslint.config.cjs",
              "eslint.config.ts",
              "eslint.config.mts",
              "eslint.config.cts",
              "package.json"
            )(fname)
            if dir then
              on_dir(dir)
            end
          end,
        },
        biome = {},
      })
    end,
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        typescript = { "deno_fmt", "prettier", stop_after_first = true },
        typescriptreact = { "deno_fmt", "prettier", stop_after_first = true },
        javascript = { "deno_fmt", "prettier", stop_after_first = true },
        javascriptreact = { "deno_fmt", "prettier", stop_after_first = true },
        css = { "biome", "prettier", stop_after_first = true },
        scss = { "prettier" },
        html = { "prettier" },
        json = { "biome", "prettier", stop_after_first = true },
        jsonc = { "biome", "prettier", stop_after_first = true },
      },
      formatters = {
        deno_fmt = {
          condition = function(_, ctx)
            return require("lspconfig.util").root_pattern("deno.json", "deno.jsonc")(ctx.filename) ~= nil
          end,
        },
        biome = {
          condition = function(_, ctx)
            return require("lspconfig.util").root_pattern("biome.json", "biome.jsonc")(ctx.filename) ~= nil
          end,
        },
      },
    },
  },
}
