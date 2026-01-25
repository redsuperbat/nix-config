---@module "lazy"
---@type LazySpec
return {
  "jake-stewart/multicursor.nvim",
  config = function()
    local mc = require("multicursor-nvim")
    mc.setup()

    mc.addKeymapLayer(function(layerSet)
      layerSet("n", "<esc>", function()
        if not mc.cursorsEnabled() then
          mc.enableCursors()
        else
          mc.clearCursors()
        end
      end)
    end)
  end,
  keys = {
    {
      "M",
      function()
        require("multicursor-nvim").matchCursors()
      end,
      mode = { "x" },
      desc = "Multicursor",
    },
    {
      "<leader>n",
      function()
        require("multicursor-nvim").matchAddCursor(1)
      end,
      mode = { "x" },
      desc = "Multicursor",
    },
  },
}
