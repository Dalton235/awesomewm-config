local wibox = require("wibox")
local dpi = require("beautiful").xresources.apply_dpi

-- Return function to create a clock widget
return function()
  -- Create text clock
  local textclock = wibox.widget.textclock('<span font="Roboto Mono bold 11">%a. %d.%m.%Y, %H:%M</span>')

  -- Create container containing the textclock
  local clock = wibox.container.margin(textclock, dpi(13), dpi(13), dpi(8), dpi(8))

  return clock
end
