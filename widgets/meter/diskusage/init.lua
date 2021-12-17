local beautiful = require("beautiful")
local watch = require("awful.widget.watch")
local icons = require("theme.icons")
local iconContainer = require("widgets.general.icon-container")
local widgetGroup = require("widgets.general.widget-group")
local barFactory = require("widgets.general.bar")

-- Create bar widget
local bar = barFactory(20, beautiful.background.hue_800, beautiful.primary.hue_500)
-- Create icon widget
local icon = iconContainer(icons.harddisk, 6, false, false)

-- Watcher on disk file system disk usage
watch(
  [[bash -c "df -h /home|grep '^/' | awk '{print $5}'"]],
  300,
  function(_, stdout)
    -- Read consumed space from stdout
    local space_consumed = stdout:match("(%d+)")
    -- Set slider value
    bar:set_value(tonumber(space_consumed))
    collectgarbage("collect")
  end
)

-- Return diskusage widget
return widgetGroup({icon, bar}, {20, 5, 20, 5}, 59, 20)
