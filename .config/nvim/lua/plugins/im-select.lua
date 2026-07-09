local util = require("util")

return {
  {
    "keaising/im-select.nvim",
    event = "VeryLazy",
    opts = {
      default_im_select = "com.apple.keylayout.ABC",
      default_command = util.find_executable({
        "/opt/homebrew/bin/macism",
        "/usr/local/bin/macism",
      }, "macism"),
      set_default_events = { "InsertLeave", "CmdlineLeave" },
      set_previous_events = {},
    },
  },
}
