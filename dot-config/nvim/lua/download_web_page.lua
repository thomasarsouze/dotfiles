local notes_dir = "~/test_notes/"

local function sanitize_filename(str)
  return str:gsub("https?://", ""):gsub("[^a-zA-Z0-9-_]", "_"):sub(1, 80)
end

local function download_webpage(url)
  if not url or url == "" then
    print("Usage: :DownloadWebPage <url>")
    return
  end

  -- Run the shell command
  local title_cmd = "curl --no-progress-meter " .. vim.fn.shellescape(url) .. " | grep -i '<title>'"
  local title = vim.fn.system(title_cmd):gsub("<.->", ""):gsub("\n", "")

  local cmd = "curl --no-progress-meter " .. vim.fn.shellescape(url) .. " | html2markdown"
  local output = vim.fn.systemlist(cmd)

  if vim.v.shell_error ~= 0 then
    print("Shell error: " .. vim.v.shell_error)
    print(vim.inspect(output))
    print("Error fetching page")
    return
  end

  -- Generate filename
  local base = title ~= "" and title or url
  local filename = sanitize_filename(base) .. ".md"
  local filepath = vim.fn.expand(notes_dir .. "/" .. filename)

  -- Metadata
  local now = os.date("%Y-%m-%d %H:%M:%S")

  local metadata = {
    "---",
    "url: " .. url,
    "title: " .. (title ~= "" and title or "Unknown"),
    "downloaded: " .. now,
    "tags: [web, article]",
    "author: ",
    "published: ",
    "---",
    "",
  }

  -- Create new buffer
  vim.cmd("enew")
  local buf = vim.api.nvim_get_current_buf()

  -- Insert content
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.list_extend(metadata, output))

  -- Set filetype
  vim.bo[buf].filetype = "markdown"

  -- Save file
  vim.cmd("write " .. filepath)

  print("Saved to " .. filepath)
end

-- Create command
vim.api.nvim_create_user_command("DownloadWebPage", function(opts)
  download_webpage(opts.args)
end, {
  nargs = 1,
})
