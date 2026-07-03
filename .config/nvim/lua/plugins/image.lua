return {
  "3rd/image.nvim",
  build = false,
  keys = {
    {
      "<leader>i",
      function()
        if require("image").is_enabled() then
          require("image").disable()
          vim.cmd("edit!")
          vim.bo.buftype = ""
          vim.bo.modifiable = true
          vim.cmd("setlocal number< cursorline< signcolumn< colorcolumn<")
        else
          require("image").enable()
          vim.cmd("edit!")
        end
      end,
      desc = "Toggle image/text view",
    },
  },
  opts = {
    backend = "kitty",
    processor = "magick_cli",
    integrations = {
      markdown = {
        enabled = true,
        clear_in_insert_mode = false,
        download_remote_images = true,
        only_render_image_at_cursor = false,
        filetypes = { "markdown", "vimwiki" },
      },
    },
    max_width = nil,
    max_height = nil,
    max_width_window_percentage = nil,
    max_height_window_percentage = 50,
    window_overlap_clear_enabled = true,
    window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
    hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif", "*.svg" },
  },
}
