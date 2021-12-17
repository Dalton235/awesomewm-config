local beautiful = require("beautiful")
local watch = require("awful.widget.watch")
local icons = require("theme.icons")
local iconContainer = require("widgets.general.icon-container")
local widgetGroup = require("widgets.general.widget-group")
local barFactory = require("widgets.general.bar")

local total_prev = 0
local idle_prev = 0

-- Create bar widget
local bar = barFactory(20, beautiful.background.hue_800, beautiful.primary.hue_500)
-- Create icon widget
local icon = iconContainer(icons.chart, 6, false, false)

-- Watcher on proc statistics of the cpu
watch(
  [[bash -c "cat /proc/stat | grep '^cpu '"]],
  5,
  function(_, stdout)
    -- Read cpu load from stdout
    local user, nice, system, idle, iowait, irq, softirq, steal, _, _ =
      stdout:match("(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s")

    -- Calculate correct total cpu load
    local total = user + nice + system + idle + iowait + irq + softirq + steal
    local diff_idle = idle - idle_prev
    local diff_total = total - total_prev
    local diff_usage = (1000 * (diff_total - diff_idle) / diff_total + 5) / 10

    -- Set bar value
    bar:set_value(diff_usage)

    -- Remember current values as previous values
    total_prev = total
    idle_prev = idle
    collectgarbage("collect")
  end
)

-- Return cpu-meter widget
return widgetGroup({icon, bar}, {20, 5, 20, 5}, 59, 20)
