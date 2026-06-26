return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "vtsls" })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local root_pattern = require("lspconfig.util").root_pattern

      opts.servers = vim.tbl_deep_extend("force", opts.servers or {}, {
        -- deno.json(c) があるプロジェクトでは起動しない
        vtsls = {
          mason = false,
          root_dir = function(bufnr, on_dir)
            local fname = vim.api.nvim_buf_get_name(bufnr)
            local deno_filepath = root_pattern("deno.json", "deno.jsonc")(fname)
            if deno_filepath ~= nil then
              return
            end
            on_dir(root_pattern("tsconfig.json", "package.json")(fname))
          end,
        },
        -- deno.json(c) があるプロジェクトでのみ起動
        denols = {
          mason = false,
          root_dir = function(bufnr, on_dir)
            local fname = vim.api.nvim_buf_get_name(bufnr)
            local filepath = root_pattern("deno.json", "deno.jsonc")(fname)
            if filepath == nil then
              return
            end
            on_dir(filepath)
          end,
          handlers = {
            -- exports フィールドのない npm パッケージのサブパス import エラーを除外する。
            -- denols は pull 型診断 (textDocument/diagnostic) を使うため、
            -- push 型 (textDocument/publishDiagnostics) ではなくこちらを上書きする必要がある。
            ["textDocument/diagnostic"] = function(err, result, ctx, config)
              if result and result.items then
                result.items = vim.tbl_filter(function(d)
                  return not (d.message and d.message:find("does not define an export", 1, true))
                end, result.items)
              end
              vim.lsp.diagnostic.on_diagnostic(err, result, ctx, config)
            end,
          },
        },
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "javascript",
        "typescript",
        "tsx",
      })
    end,
  },
}
