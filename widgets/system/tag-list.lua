local awful = require("awful")
local wibox = require("wibox")
local dpi = require("beautiful").xresources.apply_dpi
local modkey = require("configuration.keybindings").modKey

-- Return function to create a taglist
return function(screen)
  -- Create an AwesomeWM internal taglist widget
  local taglist =
    awful.widget.taglist {
    screen = screen,
    filter = awful.widget.taglist.filter.all,
    buttons = awful.util.table.join(
      -- Event-Handler: Left click
      awful.button(
        {},
        1,
        function(t)
          t:view_only()
        end
      ),
      -- Event-Handler: Mod+Left click
      awful.button(
        {modkey},
        1,
        function(t)
          if _G.client.focus then
            _G.client.focus:move_to_tag(t)
            t:view_only()
          end
        end
      ),
      -- Event-Handler: Right click
      awful.button({}, 3, awful.tag.viewtoggle),
      -- Event-Handler: Scroll up
      awful.button(
        {},
        4,
        function(t)
          awful.tag.viewprev(t.screen)
        end
      ),
      -- Event-Handler: Scroll down
      awful.button(
        {},
        5,
        function(t)
          awful.tag.viewnext(t.screen)
        end
      )
    ),
    layout = wibox.layout.fixed.horizontal(),
    widget_template = {
      {
        {
          {
            id = "icon_role",
            widget = wibox.widget.imagebox
          },
          margins = dpi(10),
          widget = wibox.container.margin
        },
        id = "background_role",
        widget = wibox.container.background
      },
      -- Unfortunately a template is needed so clickable-container cannot be used here
      widget = wibox.container.background,
      create_callback = function(self)
        -- On mouse-enter, change the transparency and the cursor
        self:connect_signal(
          "mouse::enter",
          function()
            self.bg = "#ffffff11"
            local w = _G.mouse.current_wibox
            if w then
              self.old_cursor, self.old_wibox = w.cursor, w
              w.cursor = "hand1"
            end
          end
        )
        -- On mouse-leave, change to the old transparency and cursor
        self:connect_signal(
          "mouse::leave",
          function()
            self.bg = "#ffffff00"
            if self.old_wibox then
              self.old_wibox.cursor = self.old_cursor
              self.old_wibox = nil
            end
          end
        )
        -- Change transparency on mouse click
        self:connect_signal(
          "button::press",
          function()
            self.bg = "#ffffff22"
          end
        )
        -- Change transparency back after mouse click
        self:connect_signal(
          "button::release",
          function()
            self.bg = "#ffffff11"
          end
        )
      end
    }
  }
  return taglist
end
