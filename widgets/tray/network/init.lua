local awful = require("awful")
local watch = require("awful.widget.watch")
local gears = require("gears")
local icons = require("theme.icons")
local iconContainer = require("widgets.general.icon-container")

local interface = "enp0s31f6"
local status = 0

-- Create icon container
local networkIcon = iconContainer(icons.networkOff, 5, false, true)

-- Create widget click events
networkIcon:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        awful.spawn("nm-connection-editor")
      end
    )
  )
)
-- Define popup on mouse hover
awful.tooltip(
  {
    objects = {networkIcon},
    mode = "mouse",
    timer_function = function()
      if (status == 0) then
        return "Disconnected"
      elseif (status == 1) then
        return "Connected - No internet"
      else
        return "Connected"
      end
    end
  }
)

-- Watcher on network connection
watch(
  gears.filesystem.get_configuration_dir() .. "/widgets/tray/network/check-network.sh " .. interface,
  300,
  function(_, stdout)
    -- Status of connection to the network
    status = tonumber(stdout:match("(%d+)"))
    -- Set icon based on connection status
    if (status == 0) then
      -- Interface is not connected to any network
      networkIcon:change_icon(icons.networkOff)
    elseif (status == 1) then
      -- Interface is connected to a network but not to the internet
      networkIcon:change_icon(icons.networkAlert)
    else
      -- Interface is connected to the internet
      networkIcon:change_icon(icons.networkConnected)
    end
    collectgarbage("collect")
  end,
  networkIcon
)

return networkIcon
