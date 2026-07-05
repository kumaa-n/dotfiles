return {
  {
    "brianhuster/live-preview.nvim",
    cmd = { "LivePreview" },
    opts = {},
    keys = {
      { "<leader>h", "", mode = { "n", "v" }, desc = "HTML" },
      { "<leader>hp", "<cmd>LivePreview start<cr>", desc = "Start HTML Live Preview" },
      { "<leader>hP", "<cmd>LivePreview close<cr>", desc = "Stop HTML Live Preview" },
      { "<leader>hf", "<cmd>LivePreview pick<cr>", desc = "Pick File to Preview" },
    },
  },
}
