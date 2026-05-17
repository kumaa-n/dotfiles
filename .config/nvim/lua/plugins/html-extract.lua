local function build_selectors(lines)
  local selectors = {}
  local seen = {}

  for _, line in ipairs(lines) do
    for classes in line:gmatch('class="([^"]*)"') do
      for cls in classes:gmatch("%S+") do
        local selector = "." .. cls
        if not seen[selector] then
          seen[selector] = true
          table.insert(selectors, selector .. " {\n\n}")
        end
      end
    end

    for id in line:gmatch('id="([^"]*)"') do
      local selector = "#" .. id
      if not seen[selector] then
        seen[selector] = true
        table.insert(selectors, selector .. " {\n\n}")
      end
    end
  end

  if #selectors == 0 then
    vim.notify("class/id が見つかりませんでした", vim.log.levels.WARN)
    return
  end

  vim.fn.setreg("+", table.concat(selectors, "\n\n"))
  vim.notify(#selectors .. " 件のセレクターをコピーしました", vim.log.levels.INFO)
end

vim.api.nvim_create_user_command("HtmlExtract", function(opts)
  local lines = vim.api.nvim_buf_get_lines(0, opts.line1 - 1, opts.line2, false)
  build_selectors(lines)
end, { range = true })

vim.keymap.set("n", "<leader>hx", "<cmd>%HtmlExtract<CR>", { desc = "Extract HTML class/id as CSS selectors (whole buffer)" })
vim.keymap.set("v", "<leader>hx", ":HtmlExtract<CR>", { desc = "Extract HTML class/id as CSS selectors (selection)" })

return {}
