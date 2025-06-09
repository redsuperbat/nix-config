local bg = "#1f1f28"

--- @param group string | string[]
local function set_bg(group)
  if type(group) == "string" then
    return vim.api.nvim_set_hl(0, group, { bg = bg })
  end

  for _, v in ipairs(group) do
    set_bg(v)
  end
end

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    set_bg({ "FloatBorder", "NormalFloat" })
  end,
})

return {
  bg = bg,
  set_bg = set_bg,
}
