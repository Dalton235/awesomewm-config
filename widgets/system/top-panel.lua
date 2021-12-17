local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local wibox = require("wibox")
local dpi = require("beautiful").xresources.apply_dpi
local apps = require("configuration.apps")
local icons = require("theme.icons")
local iconContainer = require("widgets.general.icon-container")
local TagList = require("widgets.system.tag-list")
local clock = require("widgets.system.clock")
local trayWidgets = require("widgets.tray")

-- Function to create a new top panel
return function(screen)
  local panelHeight = dpi(42)

  local panel =
    wibox(
    {
      ontop = true,
      screen = screen,
      height = panelHeight,
      width = screen.geometry.width,
      x = screen.geometry.x,
      y = screen.geometry.y,
      bg = beautiful.background.hue_800,
      fg = beautiful.fg_normal
    }
  )

  -- Set reserved screen space
  panel:struts(
    {
      top = panelHeight
    }
  )

  -- Create rofi launch button
  local panelButton = iconContainer(icons.menu, 0, false, true, beautiful.primary.hue_500)

  -- Rofi launch button click event
  panelButton:buttons(
    gears.table.join(
      awful.button(
        {},
        1,
        nil,
        function()
          panel:run_rofi()
        end
      )
    )
  )

  -- Function to spawn rofi launcher
  function panel:run_rofi()
    screen.overlay.visible = true
    self:moveY(600)

    -- Add focused screen name to rofi call
    local run = apps.default.rofi
    for out, _ in pairs(screen.outputs) do
      run = run .. out
    end

    _G.awesome.spawn(
      run,
      false,
      false,
      false,
      false,
      function()
        self:moveY(0)
        screen.overlay.visible = false
      end
    )
  end

  -- Function to change the y-position of the panel
  function panel:moveY(pos)
    screen.topPanel.visible = false
    screen.topPanel.y = screen.geometry.y + pos
    screen.topPanel.visible = true
  end

  -- Set which widgets get into the panel
  panel:setup {
    layout = wibox.layout.align.horizontal,
    {
      layout = wibox.layout.fixed.horizontal,
      panelButton,
      -- Add the tag-list to the panel
      TagList(screen)
    },
    {
      layout = wibox.layout.align.horizontal,
      expand = "outside",
      nil,
      -- Add a clock to the panel
      clock()
    },
    {
      layout = wibox.layout.fixed.horizontal,
      -- Add systray to the panel
      trayWidgets.systray,
      -- Add additional general widgets to the panel
      trayWidgets.updater,
      trayWidgets.volume,
      trayWidgets.network,
      trayWidgets.battery,
      -- Add a layout-switcher to the panel
      trayWidgets.layoutSwitcher(screen)
    }
  }

  return panel
end
