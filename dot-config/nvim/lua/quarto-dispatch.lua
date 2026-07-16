local M = {}

local function get_language()
  local otter = require("otter.tools.functions")

  if otter.is_otter_language_context("python") then
    return "python"
  end
  if otter.is_otter_language_context("r") then
    return "r"
  end
  if otter.is_otter_language_context("julia") then
    return "julia"
  end
  return nil
end

function M.run_line()
  local lang = get_language()

  if lang == "python" then
    vim.cmd("MoltenEvaluateLine")
    return
  end
  if lang == "julia" then
    vim.cmd("MoltenEvaluateLine")
    return
  end
  if lang == "r" then
    require("quarto.runner").run_line()
    return
  end
  vim.notify("No supported Quarto language detected", vim.log.levels.WARN)
end

function M.run_range()
  local lang = get_language()

  if lang == "python" or lang == "julia" then
    vim.cmd("MoltenEvaluateVisual")
    return
  end
  if lang == "r" then
    require("quarto.runner").run_range()
    return
  end
end

function M.run_cell()
  local lang = get_language()

  if lang == "python" or lang == "julia" then
    vim.cmd("MoltenReevaluateCell")
    return
  end
  if lang == "r" then
    require("quarto.runner").run_cell()
    return
  end
end

return M
