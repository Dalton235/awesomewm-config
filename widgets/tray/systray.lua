local wibox = require("wibox")
local dpi = require("beautiful").xresources.apply_dpi

-- Create systray widget
local systray = wibox.widget.systray()
systray:set_horizontal(true)
systray:set_base_size(dpi(16))

-- Create margin container
local container =
  wibox.widget {
  systray,
  left = dpi(11),
  top = dpi(12),
  bottom = dpi(12),
  right = dpi(16),
  widget = wibox.container.margin
}

return container
