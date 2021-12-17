local awful = require("awful")
local modKey = require("configuration.keybindings").modKey

-- Define client specific mouse button events
return {
  clientButtons = awful.util.table.join(
    awful.button(
      {},
      1,
      function(c)
        if c.focusable then
          _G.client.focus = c
          c:raise()
        end
      end
    ),
    awful.button({modKey, "Shift"}, 1, awful.mouse.client.move),
    awful.button(
      {modKey, "Shift"},
      3,
      function(c)
        awful.mouse.client.resize(c, nil)
      end
    )
  )
}
