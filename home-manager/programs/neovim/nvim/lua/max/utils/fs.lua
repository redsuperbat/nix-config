local M = {}

--- Check if the given path is a directory
--- @param path string: The path to check
--- @return boolean: True if the path is a directory, false otherwise
function M.is_dir(path)
  local stat = vim.uv.fs_stat(path)
  return stat ~= nil and stat.type == "directory"
end

--- Check if the path exists
--- @param path string: The file system path to check
--- @return boolean: Returns a boolean if the path exists
function M.exists(path)
  path = vim.fn.expand(path)
  return vim.uv.fs_stat(path) ~= nil
end

--- @param path string: Path to file
--- @return string | nil: File contents
function M.read_file(path)
  path = vim.fn.expand(path)
  local ok, data = pcall(vim.fn.readfile, path)
  if not ok then
    return nil
  end
  return table.concat(data, "\n")
end

---@param path string: Path to file
---@param content string: File content
function M.write_file(path, content)
  path = vim.fn.expand(path)
  local file = io.open(path, "w")
  if not file then
    return
  end
  file:write(content)
  file:close()
end

--- This function searches for a set of files by their names
--- starting from the directory of the given buffer and returns the
--- directory path in which a set of is located if it is found.
function M.root()
  return vim.fs.root(0, {
    "package.json",
    "lazyvim.json",
    ".gitignore",
    "tsconfig.json",
    "deno.json",
    "Cargo.toml",
  })
end

return M
