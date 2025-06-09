---@module "lazy"
---@type LazySpec
return {
  "folke/snacks.nvim",
  ---@module "snacks"
  ---@type snacks.Config
  opts = {
    dashboard = {
      preset = {
        keys = {
          { icon = " ", key = "f", desc = "Find File", action = "<leader>ff" },
          { icon = " ", key = "r", desc = "Recent Files", action = "<leader>fr" },
          { icon = " ", key = "g", desc = "Find Text", action = "<leader>sg" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
        header = [[
     .-') _   ('-.                     (`-.           _   .-')    
    ( OO ) )_(  OO)                  _(OO  )_        ( '.( OO )_  
,--./ ,--,'(,------. .-'),-----. ,--(_/   ,. \ ,-.-') ,--.   ,--.)
|   \ |  |\ |  .---'( OO'  .-.  '\   \   /(__/ |  |OO)|   `.'   | 
|    \|  | )|  |    /   |  | |  | \   \ /   /  |  |  \|         | 
|  .     |/(|  '--. \_) |  |\|  |  \   '   /,  |  |(_/|  |'.'|  | 
|  |\    |  |  .--'   \ |  | |  |   \     /__),|  |_.'|  |   |  | 
|  | \   |  |  `---.   `'  '-'  '    \   /   (_|  |   |  |   |  | 
`--'  `--'  `------'     `-----'      `-'      `--'   `--'   `--' ]],
      },
      sections = {
        { section = "header" },
        {
          section = "terminal",
          cmd = 'cowsay_centered (curl -s -H "Accept: application/json" https://icanhazdadjoke.com | jq -r .joke); sleep 0.1',
          random = 10,
          padding = 3,
        },
        { section = "keys", gap = 1, padding = 1 },
        { section = "startup" },
      },
    },
  },
}
