return {
  {
    "keaising/im-select.nvim",
    event = "VeryLazy",
    opts = {
      default_im_select = "com.apple.keylayout.ABC",
      default_command = "/opt/homebrew/bin/macism",
      set_default_events = { "InsertLeave", "CmdlineLeave" },
      set_previous_events = {},
    },
  },
}
