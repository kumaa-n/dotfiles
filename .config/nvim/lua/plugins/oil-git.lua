return {
  "benomahony/oil-git.nvim",
  dependencies = { "stevearc/oil.nvim" },
  opts = {
    highlights = {
      OilGitAdded = { link = "diffAdded" },
      OilGitModified = { link = "Special" },
      OilGitRenamed = { link = "Keyword" },
      OilGitUntracked = { link = "diffAdded" },
      OilGitIgnored = { link = "Comment" },
    },
  },
}
