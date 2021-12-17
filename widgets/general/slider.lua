local wibox = require("wibox")
local gears = require("gears")
local barFactory = require("widgets.general.bar")

-- Return function to create a slider
return function(thickness, bgColor, fgColor, hColor)
  -- Create slider widget to display the slider
  local slider =
    wibox.widget {
    maximum = 100,
    minimum = 0,
    value = 50,
    bar_height = 0,
    handle_color = hColor,
    handle_shape = gears.shape.circle,
    widget = wibox.widget.slider
  }

  -- Create bar widget to use as the slider bar. Otherwise the slider couldn't be filled with a color
  local bar = barFactory(thickness, bgColor, fgColor)

  -- Create a container stacking the bar and the slider
  local container =
    wibox.widget {
    bar,
    slider,
    layout = wibox.layout.stack
  }

  -- Function to change the value of the slider
  function container:set_value(value)
    slider.value = value
    bar.value = value
  end

  -- Function to get the current value of the slider
  function container:get_value()
    return slider.value
  end

  -- Function to change the background color of the bar
  function container:change_fgColor(color)
    bar:change_fgColor(color)
  end

  -- Emit signal when slider value changes
  slider:connect_signal(
    "property::value",
    function()
      container:emit_signal("value_changed")
    end
  )

  -- Return the slider widget
  return container
end
