local tyrannical = require("tyrannical")
local awful = require("awful")
local tags = require("configuration.tags")

-- Set possible layouts
awful.layout.layouts = {
  awful.layout.suit.max,
  awful.layout.suit.spiral.dwindle,
  awful.layout.suit.tile.bottom,
  awful.layout.suit.tile
}

-- Block popups
tyrannical.settings.block_children_focus_stealing = true
-- Default tag layout
tyrannical.settings.default_layout = awful.layout.suit.spiral.dwindle
-- Force popups/dialogs to have the same tags as the parent client
tyrannical.settings.group_children = true

tyrannical.tags = tags

-- Add client gaps to all tags
awful.screen.connect_for_each_screen(
  function(s)
    for _, tag in pairs(s.tags) do
      tag.gap = 5
      tag.gap_single_client = true
    end
  end
)

-- Hide client gaps on max layout
_G.tag.connect_signal(
  "property::layout",
  function(t)
    local currentLayout = awful.tag.getproperty(t, "layout")
    if (currentLayout == awful.layout.suit.max) then
      t.gap = 0
    else
      t.gap = 5
    end
  end
)
