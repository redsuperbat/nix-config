local M = {}

---@param pattern string
---@param buf integer
---@return boolean
function M.first_line_contains(buf, pattern)
  local first_line = vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1]
  if first_line == nil then
    return false
  end
  return first_line:match(pattern)
end

return M
