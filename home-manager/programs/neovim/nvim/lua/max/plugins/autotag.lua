---@module "lazy"
---@type LazySpec
return {
  "windwp/nvim-ts-autotag",
  event = "InsertEnter",
  opts = {
    enable_close = true, -- Auto close tags
    enable_rename = true, -- Auto rename pairs of tags
    enable_close_on_slash = true, -- Auto close on trailing </
  },
}
