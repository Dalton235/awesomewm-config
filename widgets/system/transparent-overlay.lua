local wibox = require("wibox")

-- Function to create a new transparent overlay
return function(screen)
  -- Transparent overlay when rofi launches
  local overlay =
    wibox {
    ontop = true,
    visible = false,
    screen = screen,
    bg = "#ffffff22",
    type = "dock",
    x = screen.geometry.x,
    y = screen.geometry.y,
    width = screen.geometry.width,
    height = screen.geometry.height
  }

  return overlay
end
