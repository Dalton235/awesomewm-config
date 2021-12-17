local wibox = require("wibox")
local gears = require("gears")
local dpi = require("beautiful").xresources.apply_dpi

-- Return function to create a progressbar
return function(thickness, bgColor, fgColor)
  -- Create progessbar widget to display the bar
  local bar =
    wibox.widget {
    max_value = 100,
    value = 50,
    shape = gears.shape.rounded_bar,
    color = fgColor,
    background_color = bgColor,
    clip = true,
    margins = {top = dpi(thickness), bottom = dpi(thickness)},
    widget = wibox.widget.progressbar
  }

  -- Function to change the value of the bar
  function set_value(value)
    bar.value = value
  end

  -- Function to change the foreground color of the bar
  function bar:change_fgColor(color)
    bar.color = color
  end

  -- Return the bar widget
  return bar
end
