-- ~/.config/nvim/lua/plugins/notify.lua
return {
  "rcarriga/nvim-notify",
  opts = {
    stages = "static", -- Disables sliding animation for instant display
    render = "minimal", -- Plain text without headers or heavy borders
    timeout = 2500,
    background_colour = "#000000",
  },
}
