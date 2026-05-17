return {
  "RaafatTurki/hex.nvim",
  ft = { "hex", "efi" },
  opts = {},
  event = { "BufRead" },
  cmd = {
    "HexDump",
    "HexAssemble",
    "HexToggle",
  },
}
