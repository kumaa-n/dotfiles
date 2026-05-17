return {
  "hat0uma/csvview.nvim",
  ft = { "csv", "tsv" },
  opts = {
    parser = {
      async_chunksize = 50,
    },
    view = {
      min_column_width = 5,
      spacing = 2,
      display_mode = "highlight",
    },
  },
}
