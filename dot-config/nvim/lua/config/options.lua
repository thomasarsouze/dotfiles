-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
-- Handle markdown.mdx as markdown
vim.filetype.add({
  extension = {
    mdx = "markdown",
  },
})

-- yaml subtype
vim.filetype.add({
  filename = {
    ["docker-compose.yml"] = "yaml",
    ["docker-compose.yaml"] = "yaml",
    [".gitlab-ci.yml"] = "yaml",
  },
  pattern = {
    [".*values%.ya?ml"] = "yaml",
  },
})
