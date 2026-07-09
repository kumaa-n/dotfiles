return {
  "stevearc/oil.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "refractalize/oil-git-status.nvim",
  },
  lazy = false,
  keys = {
    { "<leader>o", "<cmd>Oil<cr>", desc = "Oil (open parent directory)" },
  },
  opts = {
    columns = {
      "icon",
    },
    win_options = {
      signcolumn = "yes:2",
      statuscolumn = "",
    },
    skip_confirm_for_simple_edits = false,
    view_options = {
      show_hidden = true,
    },
    keymaps = {
      ["g?"] = "actions.show_help",
      ["<CR>"] = "actions.select",
      ["<C-s>"] = { "actions.select", opts = { vertical = true }, desc = "Open in vertical split" },
      ["<C-h>"] = { "actions.select", opts = { horizontal = true }, desc = "Open in horizontal split" },
      ["<C-p>"] = "actions.preview",
      ["<C-c>"] = "actions.close",
      ["-"] = "actions.parent",
      ["_"] = "actions.open_cwd",
      ["`"] = "actions.cd",
      ["~"] = { "actions.cd", opts = { scope = "tab" }, desc = "Change tab cwd" },
      ["g."] = "actions.toggle_hidden",
    },
    use_default_keymaps = false,
  },
  config = function(_, opts)
    require("oil").setup(opts)
    require("oil-git-status").setup()
  end,
}
