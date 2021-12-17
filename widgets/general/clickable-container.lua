local wibox = require("wibox")

-- Return function to create a clickable-container
return function(widget)
  -- Create container for the background
  local background =
    wibox.widget {
    widget,
    widget = wibox.container.background
  }

  -- Remember old cursor and wibox
  local old_cursor, old_wibox

  -- On mouse-enter, change the transparency and the cursor
  background:connect_signal(
    "mouse::enter",
    function()
      background.bg = "#ffffff11"
      local w = _G.mouse.current_wibox
      if w then
        old_cursor, old_wibox = w.cursor, w
        w.cursor = "hand1"
      end
    end
  )

  -- On mouse-leave, change to the old transparency and cursor
  background:connect_signal(
    "mouse::leave",
    function()
      background.bg = "#ffffff00"
      if old_wibox then
        old_wibox.cursor = old_cursor
        old_wibox = nil
      end
    end
  )

  -- Change transparency on mouse click
  background:connect_signal(
    "button::press",
    function()
      background.bg = "#ffffff22"
    end
  )

  -- Change transparency back after mouse click
  background:connect_signal(
    "button::release",
    function()
      background.bg = "#ffffff11"
    end
  )

  -- Return prepared container
  return background
end
