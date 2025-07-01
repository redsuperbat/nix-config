local buffer = require("max.utils.buffer")

local M = {}

---Checks if the current file contains a shebang with the deno executable
---@param buf integer
function M.is_deno(buf)
  return buffer.first_line_contains(buf, "^#!.*deno")
end

return M
