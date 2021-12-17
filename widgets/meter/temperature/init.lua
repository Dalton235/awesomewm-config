local beautiful = require("beautiful")
local watch = require("awful.widget.watch")
local icons = require("theme.icons")
local iconContainer = require("widgets.general.icon-container")
local widgetGroup = require("widgets.general.widget-group")
local barFactory = require("widgets.general.bar")

-- Create bar widget
local bar = barFactory(20, beautiful.background.hue_800, beautiful.primary.hue_500)
-- Create icon widget
local icon = iconContainer(icons.thermometer, 6, false, false)

-- Max temperature of the system to calculate a percentage value
local max_temp = 100

-- Watcher on memory usage
watch(
  'bash -c "cat /sys/class/thermal/thermal_zone0/temp"',
  5,
  function(_, stdout)
    -- Read temperature from stdout
    local temp = stdout:match("(%d+)")
    -- Set slider value
    bar:set_value((temp / 1000) / max_temp * 100)
    collectgarbage("collect")
  end
)

-- Return temp widget
return widgetGroup({icon, bar}, {20, 5, 20, 5}, 59, 20)
