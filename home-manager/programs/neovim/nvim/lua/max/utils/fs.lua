local M = {}

--- Check if the given path is a directory
--- @param path string: The path to check
--- @return boolean: True if the path is a directory, false otherwise
function M.is_dir(path)
  local stat = vim.uv.fs_stat(path)
  return stat ~= nil and stat.type == "directory"
end

--- Check if the path exists using the Neovim uv library
--- @param path string: The file system path to check
--- @return boolean: Returns a boolean if the path exists, nil otherwise
function M.path_exists(path)
  return vim.uv.fs_stat(path) ~= nil
end

--- This function searches for a file by its name starting from
--- the directory of the given buffer and traversing upwards
--- If the file is found, the function returns the path to the
--- file. If not, it returns nil.
--- @param filename string
--- @param bufnr number
--- @return string | nil
function M.find_file(filename, bufnr)
  local starting_dir = vim.api.nvim_buf_get_name(bufnr)
  local file_path = vim.fs.find(filename, {
    upward = true,
    path = starting_dir,
    type = "file",
  })[1]
  if file_path then
    return file_path
  end
  return nil
end

--- This function searches for a file by its name starting from the directory of the given buffer
--- and returns the directory path in which the file is located if it is found. If not, it returns nil.
--- @param filename string: The name of the file to search for.
--- @param bufnr number: The buffer number to start the search from.
--- @return string | nil: The directory path containing the file or nil if not found.
function M.find_file_directory(filename, bufnr)
  local file_path = M.find_file(filename, bufnr)
  if file_path then
    return vim.fn.fnamemodify(file_path, ":h")
  end
  return nil
end

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
