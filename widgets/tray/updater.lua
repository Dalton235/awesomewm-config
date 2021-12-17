local awful = require("awful")
local watch = require("awful.widget.watch")
local gears = require("gears")
local icons = require("theme.icons")
local iconContainer = require("widgets.general.icon-container")

local updateAvailable = false
local numOfUpdatesAvailable

-- Create icon container
local updaterIcon = iconContainer(icons.package, 5, false, true)

-- Create widget click events
updaterIcon:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        if updateAvailable then
          awful.spawn("pamac-manager --updates")
        else
          awful.spawn("pamac-manager")
        end
      end
    )
  )
)

-- Define popup on mouse hover
awful.tooltip(
  {
    objects = {updaterIcon},
    mode = "mouse",
    timer_function = function()
      if updateAvailable then
        return numOfUpdatesAvailable .. " update(s) is/are available."
      else
        return "We are up-to-date!"
      end
    end
  }
)

-- Watcher to check for new updates
watch(
  "pamac checkupdates",
  300,
  function(_, stdout)
    -- Read number of available updates
    numOfUpdatesAvailable = tonumber(stdout:match(".-\n"):match("%d*"))

    -- Set icon based on number of packages
    if (numOfUpdatesAvailable ~= nil) then
      updateAvailable = true
      updaterIcon:change_icon(icons.packageUp)
    else
      updateAvailable = false
      updaterIcon:change_icon(icons.package)
    end
  end,
  updaterIcon
)
return updaterIcon
