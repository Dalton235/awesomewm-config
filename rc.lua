local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
require("awful.autofocus")

-- Initialize custom theme for beautiful
beautiful.init(require("theme"))

-- Initialize all modules
require("module.global-functions")
require("module.client-decorations")
require("module.client-rules")
require("module.notifications")
require("module.exit-screen")
require("module.setup-system-ui")
require("module.tag-settings")
require("module.autostart")
_G.root.keys(require("configuration.keybindings").keybinds)

-- Set wallpaper on all screens
awful.screen.connect_for_each_screen(
  function(s)
    gears.wallpaper.fit(beautiful.wallpaper, s)
  end
)
