local beautiful = require("beautiful")
local watch = require("awful.widget.watch")
local icons = require("theme.icons")
local iconContainer = require("widgets.general.icon-container")
local widgetGroup = require("widgets.general.widget-group")
local barFactory = require("widgets.general.bar")

-- Create bar widget
local bar = barFactory(20, beautiful.background.hue_800, beautiful.primary.hue_500)
-- Create icon widget
local icon = iconContainer(icons.memory, 6, false, false)

-- Watcher on memory usage
watch(
  'bash -c "free | grep -z Mem.*Swap.*"',
  10,
  function(_, stdout)
    -- Read total and used memory from stdout
    local total, used, _, _, _, _, _, _, _ =
      stdout:match("(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*Swap:%s*(%d+)%s*(%d+)%s*(%d+)")
    -- Set slider value
    bar:set_value(used / total * 100)
    collectgarbage("collect")
  end
)

-- Return ram-usage widget
return widgetGroup({icon, bar}, {20, 5, 20, 5}, 59, 20)
