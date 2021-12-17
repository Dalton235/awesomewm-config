local wibox = require("wibox")
local gears = require("gears")
local dpi = require("beautiful").xresources.apply_dpi
local clickableContainer = require("widgets.general.clickable-container")

-- Return function to create an icon-container
return function(icon, padding, circle, clickable, bgColor, containerSize, iconSize)
  -- Create an imagebox to hold the icon
  local imagebox =
    wibox.widget {
    image = icon,
    widget = wibox.widget.imagebox
  }

  -- Create background container for the click styles
  local clickContainer
  if (clickable) then
    clickContainer = clickableContainer(nil)
  else
    clickContainer = wibox.widget {widget = wibox.container.background}
  end

  -- Create icon-container widget
  local iconContainer =
    wibox.widget {
    wibox.widget {
      wibox.widget {
        imagebox,
        top = iconSize and dpi(iconSize) or dpi(6),
        left = iconSize and dpi(iconSize) or dpi(6),
        right = iconSize and dpi(iconSize) or dpi(6),
        bottom = iconSize and dpi(iconSize) or dpi(6),
        widget = wibox.container.margin
      },
      -- Button shape is based on user input
      shape = circle and gears.shape.circle or gears.shape.rectangle,
      forced_width = containerSize and dpi(containerSize) or nil,
      forced_height = containerSize and dpi(containerSize) or nil,
      widget = clickContainer
    },
    top = dpi(padding),
    left = dpi(padding),
    right = dpi(padding),
    bottom = dpi(padding),
    widget = wibox.container.margin
  }

  local backgroundContainer =
    wibox.widget {
    iconContainer,
    widget = wibox.container.background,
    bg = bgColor
  }

  -- Function to change the icon
  function backgroundContainer:change_icon(new_icon)
    imagebox.image = new_icon
  end

  -- Return widget
  return backgroundContainer
end
