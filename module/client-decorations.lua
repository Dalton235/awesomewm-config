local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")

local changesOnScreenCalled = false

-- General configuration for client decorations
local function renderClient(client, mode)
  -- Check if client is already decorated or does not need to be decorated
  if client.skip_decoration or (client.rendering_mode == mode) then
    return
  end

  -- Set rendering mode defaults
  client.rendering_mode = mode
  client.floating = false
  client.maximized = false
  client.above = false
  client.below = false
  client.ontop = false
  client.sticky = false
  client.maximized_horizontal = false
  client.maximized_vertical = false

  if client.rendering_mode == "maximized" then
    -- Maximized: borderless rectangle
    client.border_width = 0
    client.shape = function(cr, w, h)
      gears.shape.rectangle(cr, w, h)
    end
  else
    -- Else: rounded rectangle
    client.border_width = beautiful.border_width
    client.shape = function(cr, w, h)
      gears.shape.rounded_rect(cr, w, h, 8)
    end
  end
end

-- Process changes on the screen
local function changesOnScreen(currentScreen)
  local clientsToManage = {}

  -- Get list of clients which need to be re-decorated
  for _, client in pairs(currentScreen.clients) do
    if not client.skip_decoration and not client.hidden then
      table.insert(clientsToManage, client)
    end
  end

  -- Set client mode by tags mode
  if (currentScreen.selected_tag ~= nil) then
    if (currentScreen.selected_tag.layout == awful.layout.suit.max) then
      currentScreen.client_mode = "maximized"
    elseif (currentScreen.selected_tag.layout == awful.layout.suit.spiral.dwindle) then
      currentScreen.client_mode = "dwindle"
    elseif (currentScreen.selected_tag.layout == awful.layout.suit.tile.bottom) then
      currentScreen.client_mode = "tilebottom"
    elseif (currentScreen.selected_tag.layout == awful.layout.suit.tile) then
      currentScreen.client_mode = "tile"
    end
  end

  -- Decorate clients according to the client mode
  for _, client in pairs(clientsToManage) do
    renderClient(client, currentScreen.client_mode)
  end

  changesOnScreenCalled = false
end

-- Callback function for client events: manage, unmanage, property::hidden, property::minimized, property::fullscreen
local function clientCallback(client)
  -- Only start changes if they are not already processing
  if not changesOnScreenCalled then
    -- Check if client does not need to be decorated
    if not client.skip_decoration and client.screen then
      changesOnScreenCalled = true
      local screen = client.screen
      gears.timer.delayed_call(
        function()
          -- Start processing changes on screen
          changesOnScreen(screen)
        end
      )
    end
  end
end

-- Callback function for tag events: selected, layout
local function tagCallback(tag)
  -- Only start changes if they are not already processing
  if not changesOnScreenCalled then
    if tag.screen then
      changesOnScreenCalled = true
      local screen = tag.screen
      gears.timer.delayed_call(
        function()
          -- Start processing changes on screen
          changesOnScreen(screen)
        end
      )
    end
  end
end

-- Set client callbacks (interaction with clients)
_G.client.connect_signal("manage", clientCallback)
_G.client.connect_signal("unmanage", clientCallback)
_G.client.connect_signal("property::hidden", clientCallback)
_G.client.connect_signal("property::minimized", clientCallback)
_G.client.connect_signal(
  "property::fullscreen",
  function(c)
    if c.fullscreen then
      renderClient(c, "maximized")
    else
      clientCallback(c)
    end
  end
)
_G.client.connect_signal(
  "focus",
  function(c)
    c.border_color = beautiful.border_focus
  end
)
_G.client.connect_signal(
  "unfocus",
  function(c)
    c.border_color = beautiful.border_normal
  end
)

-- Set tag callbacks (interactions with tags)
_G.tag.connect_signal("property::selected", tagCallback)
_G.tag.connect_signal("property::layout", tagCallback)
