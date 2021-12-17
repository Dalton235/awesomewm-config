local awful = require("awful")
local clickableContainer = require("widgets.general.clickable-container")

-- Return function to create a layout-switcher button
return function(screen)
  -- Create a click-container containing the AwesomeWM internal layoutbox widget
  local layoutBtn = clickableContainer(awful.widget.layoutbox(screen))
  -- Add click event handler
  layoutBtn:buttons(
    awful.util.table.join(
      awful.button(
        {},
        1,
        function()
          awful.layout.inc(1)
        end
      )
    )
  )
  -- Return layout-switcher button
  return layoutBtn
end
