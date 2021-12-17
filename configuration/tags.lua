local awful = require("awful")
local icons = require("theme.icons")

-- Define all tags (uses tyrannical)
return {
  {
    name = "browser",
    icon = icons.chrome,
    screen = 1,
    init = true,
    exclusive = false,
    selected = true
  },
  {
    name = "music",
    icon = icons.music,
    screen = 1,
    init = true,
    exclusive = false
  },
  {
    name = "terminal",
    icon = icons.code,
    screen = _G.screen.count() > 1 and 2 or 1,
    layout = awful.layout.suit.tile.bottom,
    init = true,
    exclusive = false,
    selected = _G.screen.count() > 1 and true or false
  },
  {
    name = "password",
    icon = icons.folder,
    screen = _G.screen.count() > 1 and 2 or 1,
    init = true,
    exclusive = false
  },
  {
    name = "messenger",
    icon = icons.social,
    screen = _G.screen.count() > 1 and 2 or 1,
    init = true,
    exclusive = false
  },
  {
    name = "code",
    icon = icons.code,
    screen = _G.screen.count() > 2 and 3 or 1,
    init = true,
    exclusive = false,
    selected = _G.screen.count() > 2 and true or false
  },
  {
    name = "empty",
    icon = icons.lab,
    screen = {1, 2, 3},
    init = true,
    exclusive = false,
    fallback = true
  }
}
