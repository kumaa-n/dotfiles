local M = {}

-- 候補パスを順に調べ、最初に実行可能だったものを返す。
function M.find_executable(candidates, fallback)
  for _, path in ipairs(candidates) do
    if vim.fn.executable(path) == 1 then
      return path
    end
  end
  return fallback or candidates[#candidates]
end

return M
