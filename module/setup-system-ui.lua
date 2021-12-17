local awful = require("awful")
local transparentOverlay = require("widgets.system.transparent-overlay")
local topPanel = require("widgets.system.top-panel")

-- Add top and left panel to each screen
awful.screen.connect_for_each_screen(
  function(s)
    -- Create the switchable transparent overlay
    s.overlay = transparentOverlay(s)
    -- Create the top panel
    s.topPanel = topPanel(s)
  end
)

-- Hide bars when a client goes fullscreen
local function updateBarsVisibility()
  for s in _G.screen do
    if s.selected_tag then
      local fullscreen = s.selected_tag.fullscreenMode
      s.topPanel.visible = not fullscreen
    end
  end
end

-- Signals to handle client fullscreen
_G.tag.connect_signal(
  "property::selected",
  function()
    updateBarsVisibility()
  end
)
_G.client.connect_signal(
  "property::fullscreen",
  function(c)
    c.first_tag.fullscreenMode = c.fullscreen
    updateBarsVisibility()
  end
)
_G.client.connect_signal(
  "unmanage",
  function(c)
    if c.fullscreen then
      c.screen.selected_tag.fullscreenMode = false
      updateBarsVisibility()
    end
  end
)
