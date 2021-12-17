-- Based on https://github.com/streetturtle/awesome-wm-widgets/blob/master/volume-widget/volume.lua

local awful = require("awful")
local gears = require("gears")
local watch = require("awful.widget.watch")
local spawn = require("awful.spawn")
local icons = require("theme.icons")
local iconContainer = require("widgets.general.icon-container")

local GET_VOLUME_CMD = "amixer sget Master"
local INC_VOLUME_CMD = "amixer sset Master 5%+"
local DEC_VOLUME_CMD = "amixer sset Master 5%-"
local TOG_VOLUME_CMD = "amixer sset Master toggle"

-- Create icon container
local volumeIcon = iconContainer(icons.volumeMedium, 5, false, true)

-- Function for updating widgets icon
local function updateIcon(_, stdout)
  local mute = string.match(stdout, "%[(o%D%D?)%]")
  local volume = string.match(stdout, "(%d?%d?%d)%%")
  volume = tonumber(string.format("% 3d", volume))
  if mute == "off" then
    volumeIcon:change_icon(icons.volumeMuted)
  elseif (volume >= 0 and volume < 25) then
    volumeIcon:change_icon(icons.volumeLow)
  elseif (volume < 50) then
    volumeIcon:change_icon(icons.volumeMedium)
  elseif (volume < 75) then
    volumeIcon:change_icon(icons.volumeHigh)
  elseif (volume <= 100) then
    volumeIcon:change_icon(icons.volumeFull)
  end
end

-- Create widget click events
volumeIcon:buttons(
  gears.table.join(
    awful.button(
      {},
      0,
      nil,
      function()
        spawn.easy_async(
          GET_VOLUME_CMD,
          function(stdout)
            updateIcon(_, stdout)
          end
        )
      end
    ),
    awful.button(
      {},
      1,
      nil,
      function()
        awful.spawn(TOG_VOLUME_CMD, false)
      end
    ),
    awful.button(
      {},
      4,
      nil,
      function()
        awful.spawn(INC_VOLUME_CMD, false)
      end
    ),
    awful.button(
      {},
      5,
      nil,
      function()
        awful.spawn(DEC_VOLUME_CMD, false)
      end
    )
  )
)

-- Watcher on changing volume
watch(GET_VOLUME_CMD, 1, updateIcon, volumeIcon)

return volumeIcon
