local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local icons = require("theme.icons")
local iconContainer = require("widgets.general.icon-container")
local apps = require("configuration.apps")

-- Poweroff button
local poweroff = iconContainer(icons.power, 50, true, true, nil, 200, 32)
poweroff:connect_signal(
  "button::release",
  function()
    _G.exit_screen_hide()
    awful.spawn.with_shell("sleep 1 && systemctl poweroff")
  end
)
-- Reboot button
local reboot = iconContainer(icons.restart, 50, true, true, nil, 200, 32)
reboot:connect_signal(
  "button::release",
  function()
    _G.exit_screen_hide()
    awful.spawn.with_shell("sleep 1 && systemctl reboot")
  end
)
-- Suspend button
local suspend = iconContainer(icons.sleep, 50, true, true, nil, 200, 32)
suspend:connect_signal(
  "button::release",
  function()
    _G.exit_screen_hide()
    awful.spawn.with_shell("sleep 1 && " .. apps.default.lock .. " && sleep 3 && systemctl suspend")
  end
)
-- Logout button
local logout = iconContainer(icons.logout, 50, true, true, nil, 200, 32)
logout:connect_signal(
  "button::release",
  function()
    _G.exit_screen_hide()
    _G.awesome.quit()
  end
)
-- Lock button
local lock = iconContainer(icons.lock, 50, true, true, nil, 200, 32)
lock:connect_signal(
  "button::release",
  function()
    _G.exit_screen_hide()
    awful.spawn.with_shell("sleep 1 && " .. apps.default.lock)
  end
)

-- Create the exit-screen widget
local exit_screen =
  wibox(
  {
    x = awful.screen.focused().geometry.x,
    y = awful.screen.focused().geometry.y,
    visible = false,
    ontop = true,
    type = "splash",
    height = awful.screen.focused().geometry.height,
    width = awful.screen.focused().geometry.width,
    bg = beautiful.background.hue_800 .. "dd",
    fg = beautiful.exit_screen_fg or beautiful.wibar_fg or "#FEFEFE"
  }
)

-- Mouse click handler for the exit screen
exit_screen:buttons(
  gears.table.join(
    -- Middle click - Hide exit screen
    awful.button(
      {},
      2,
      function()
        _G.exit_screen_hide()
      end
    ),
    -- Right click - Hide exit screen
    awful.button(
      {},
      3,
      function()
        _G.exit_screen_hide()
      end
    )
  )
)

-- Place buttons on the exit screen
exit_screen:setup {
  nil,
  {
    nil,
    {
      lock,
      suspend,
      logout,
      reboot,
      poweroff,
      layout = wibox.layout.fixed.horizontal
    },
    nil,
    expand = "none",
    layout = wibox.layout.align.horizontal
  },
  nil,
  expand = "none",
  layout = wibox.layout.align.vertical
}

local exit_screen_grabber

-- Set global function to show the exit screen
_G.exit_screen_show = function()
  -- Start a keygrabber to exit the screen with Esc/q
  exit_screen_grabber =
    awful.keygrabber.run(
    function(_, key, event)
      if event == "release" then
        return
      end

      if key == "Escape" or key == "q" then
        _G.exit_screen_hide()
      end
    end
  )
  exit_screen.visible = true
end
-- Set global function to hide the exit screen
_G.exit_screen_hide = function()
  awful.keygrabber.stop(exit_screen_grabber)
  exit_screen.visible = false
end
