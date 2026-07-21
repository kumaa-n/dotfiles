return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "intelephense",
        "phpcs",
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "folke/neoconf.nvim",
        cmd = "Neoconf",
        opts = {},
      },
    },
    opts = function(_, opts)
      opts.servers = opts.servers or {}

      local function expand(flat)
        local out = {}
        for key, value in pairs(flat) do
          local node = out
          local parts = vim.split(key, ".", { plain = true })
          for i = 1, #parts - 1 do
            node[parts[i]] = node[parts[i]] or {}
            node = node[parts[i]]
          end
          node[parts[#parts]] = value
        end
        return out
      end

      local settings = {}
      local found = vim.fs.find(".neoconf.json", {
        upward = true,
        path = vim.fn.getcwd(),
        type = "file",
      })[1]
      if found then
        local ok, data = pcall(vim.json.decode, table.concat(vim.fn.readfile(found), "\n"))
        local flat = ok and vim.tbl_get(data or {}, "lspconfig", "intelephense")
        if flat then
          settings = expand(flat)
        end
      end

      opts.servers.intelephense = vim.tbl_deep_extend("force", opts.servers.intelephense or {}, {
        settings = settings,
      })
    end,
  },
}
