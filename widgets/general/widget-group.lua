local wibox = require("wibox")
local dpi = require("beautiful").xresources.apply_dpi
local clickableContainer = require("widgets.general.clickable-container")

-- Return function to create a widget group
return function(widgets, margins, height, spacing, clickable, vertical, bgColor)
  -- Create layout widget which contains all content widgets
  local layout =
    wibox.widget {
    layout = vertical and wibox.layout.fixed.vertical or wibox.layout.fixed.horizontal,
    spacing = spacing and dpi(spacing) or nil
  }
  -- Add content widgets to the layout widget
  for _, widget in ipairs(widgets) do
    layout:add(widget)
  end

  -- Create group widget with the margin, background and click-container widgets
  local group =
    wibox.widget {
    wibox.widget {
      clickable and clickableContainer(layout) or layout,
      bg = bgColor,
      widget = wibox.container.background
    },
    left = dpi(margins[1]),
    top = dpi(margins[2]),
    right = dpi(margins[3]),
    bottom = dpi(margins[4]),
    forced_height = height and dpi(height) or nil,
    widget = wibox.container.margin
  }

  -- Return group widget
  return group
end
