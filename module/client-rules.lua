local awful = require("awful")
local gears = require("gears")
local mousebindings = require("configuration.mousebindings")

-- Define rules which get applied to clients
awful.rules.rules = {
  -- Wildcard rule
  {
    rule = {},
    properties = {
      focus = awful.client.focus.filter,
      raise = true,
      buttons = mousebindings.clientButtons,
      screen = awful.screen.preferred,
      placement = awful.placement.no_overlap + awful.placement.no_offscreen
    }
  },
  -- Dialog rule
  {
    rule_any = {type = {"dialog"}, role = {"pop-up", "GtkFileChooserDialog", "file transfer"}, class = {}},
    properties = {
      placement = awful.placement.centered,
      ontop = true,
      floating = true,
      drawBackdrop = true,
      shape = function()
        return function(cr, w, h)
          gears.shape.rounded_rect(cr, w, h, 8)
        end
      end,
      skip_decoration = true
    }
  }
}

-- New client rules
_G.client.connect_signal(
  "manage",
  function(c)
    -- Set new clients as the slave of already present clients
    if not _G.awesome.startup then
      awful.client.setslave(c)
    end

    -- Prevent clients from being unreachable after screen count changes
    if _G.awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
      awful.placement.no_offscreen(c)
    end
  end
)
