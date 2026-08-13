return {
  -- Blade needs no syntax plugin: Neovim already detects *.blade.php as the
  -- "blade" filetype, and nvim-treesitter's main branch ships the parser along
  -- with its highlights/injections/indents queries. The blade injections pull
  -- in php_only, so that parser has to be present too.
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "blade",
        "php",
        "php_only",
      })
    end,
  },

  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "laravel-ls",
        "blade-formatter",
        "pint",
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}

      -- Completion and go-to-definition for view(), route(), config(), env()
      -- and friends. nvim-lspconfig's own definition already targets php and
      -- blade, and roots on "artisan" so it stays out of non-Laravel projects.
      opts.servers.laravel_ls = opts.servers.laravel_ls or {}

      -- tailwindcss itself is declared in html-css.lua. Its default filetypes
      -- already cover blade, but class completion stays silent until the
      -- server is told how to read the language.
      opts.servers.tailwindcss = vim.tbl_deep_extend("force", opts.servers.tailwindcss or {}, {
        settings = {
          tailwindCSS = {
            includeLanguages = {
              blade = "html",
            },
          },
        },
      })
    end,
  },

  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.blade = { "blade-formatter" }
      -- conform's builtin pint prefers vendor/bin/pint and falls back to the
      -- one Mason installs, so both Laravel and bare PHP projects are covered.
      opts.formatters_by_ft.php = { "pint" }
    end,
  },

  {
    "adalessa/laravel.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-neotest/nvim-nio",
    },
    ft = { "php", "blade" },
    event = { "BufEnter composer.json" },
    opts = {
      features = {
        pickers = {
          provider = "snacks",
        },
      },
    },
    -- Upstream suggests <leader>l, which is already :Lazy in LazyVim, and
    -- <c-g> for the view finder, which would shadow the builtin file info.
    -- Everything lives under <leader>L instead.
    keys = {
      { "<leader>L", "", desc = "Laravel" },
      { "<leader>Ll", function() Laravel.pickers.laravel() end, desc = "Laravel: Picker" },
      { "<leader>La", function() Laravel.pickers.artisan() end, desc = "Laravel: Artisan Picker" },
      { "<leader>Lr", function() Laravel.pickers.routes() end, desc = "Laravel: Routes Picker" },
      { "<leader>Lm", function() Laravel.pickers.make() end, desc = "Laravel: Make Picker" },
      { "<leader>Lc", function() Laravel.pickers.commands() end, desc = "Laravel: Custom Commands Picker" },
      { "<leader>Lo", function() Laravel.pickers.resources() end, desc = "Laravel: Resources Picker" },
      { "<leader>Lh", function() Laravel.run("artisan docs") end, desc = "Laravel: Documentation" },
      { "<leader>Lt", function() Laravel.commands.run("actions") end, desc = "Laravel: Code Actions" },
      { "<leader>Lu", function() Laravel.commands.run("hub") end, desc = "Laravel: Artisan Hub" },
      { "<leader>Lp", function() Laravel.commands.run("command_center") end, desc = "Laravel: Command Center" },
      { "<leader>Lv", function() Laravel.commands.run("view:finder") end, desc = "Laravel: View Finder" },
      {
        "gf",
        function()
          if Laravel.app("gf").cursorOnResource() then
            return "<cmd>lua Laravel.commands.run('gf')<cr>"
          end
          return "gf"
        end,
        expr = true,
        noremap = true,
        desc = "Laravel: Go to resource",
      },
    },
  },
}
