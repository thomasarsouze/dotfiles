local M = {}

M.python = {
  jobid = nil,
  bufnr = nil,
}

local function is_quarto()
  return vim.bo.filetype == "quarto"
end

local function is_python()
  return vim.bo.filetype == "python"
end

local function next_nonblank_line()
  local last = vim.fn.line("$")
  local line = vim.fn.line(".")

  while line < last do
    line = line + 1

    if vim.fn.getline(line):match("%S") then
      vim.api.nvim_win_set_cursor(0, { line, 0 })
      return
    end
  end
end

----------------------------------------------------------
-- Manage Python REPL
----------------------------------------------------------

function M.python_running()
  if not M.python.jobid then
    return false
  end
  return vim.fn.jobwait({ M.python.jobid }, 0)[1] == -1
end

function M.start_python()
  if M.python_running() then
    return
  end
  local current = vim.api.nvim_get_current_win()

  vim.cmd("botright 80vsplit")
  vim.cmd("terminal ipython")
  M.python.bufnr = vim.api.nvim_get_current_buf()
  M.python.jobid = vim.b.terminal_job_id
  vim.api.nvim_set_current_win(current)
end

function M.start_python_autoreload()
  if M.python_running() then
    return
  end
  local current = vim.api.nvim_get_current_win()

  vim.cmd("botright 75vsplit")
  vim.cmd("terminal ipython_autoreload")
  M.python.bufnr = vim.api.nvim_get_current_buf()
  M.python.jobid = vim.b.terminal_job_id
  vim.api.nvim_set_current_win(current)
end

----------------------------------------------------
--- helper function for line selection
----------------------------------------------------

local function send(text)
  M.start_python()
  vim.api.nvim_chan_send(M.python.jobid, text)
end

----------------------------------------------------
-- send current line
----------------------------------------------------

function M.send_line()
  -- if quarto document:
  -- rely to quarto.runner to send to the backend:
  -- Molten.nvim for python chunks
  -- R.nvim for R chunks
  if is_quarto() then
    --require("quarto.runner").run_line()
    vim.cmd("MoltenEvaluateLine")
  -- if pure python file, use vim-slime
  elseif is_python() then
    local text = vim.api.nvim_get_current_line() .. "\n"
    send(text)
  else
    return
  end

  next_nonblank_line()
end

----------------------------------------------------
-- send visual selection
----------------------------------------------------

function M.send_selection()
  if is_quarto() then
    -- require("quarto.runner").run_range()
    vim.cmd("MoltenEvaluateVisual")
  elseif is_python() then
    -- leave visual mode first so the '< and '> marks are committed
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", false, true, true), "nx", false)
    local lines = vim.api.nvim_buf_get_lines(0, vim.fn.line("'<") - 1, vim.fn.line("'>"), false)
    send(table.concat(lines, "\n") .. "\n")
  end
end

----------------------------------------------------
-- send current cell
----------------------------------------------------

function M.send_cell()
  if is_quarto() then
    require("quarto.runner").run_cell()
  end
end

-- startup
function M.toggle()
  M.start_python()
end

return M
