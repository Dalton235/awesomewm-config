-- Based on https://github.com/streetturtle/awesome-wm-widgets/tree/master/battery-widget

local awful = require("awful")
local naughty = require("naughty")
local watch = require("awful.widget.watch")
local gears = require("gears")
local icons = require("theme.icons")
local iconContainer = require("widgets.general.icon-container")

-- Create icon container
local batteryIcon = iconContainer(icons.battery50, 5, false, true)

-- Create widget click events
batteryIcon:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        awful.spawn("xfce4-power-manager-settings")
      end
    )
  )
)

-- Define popup on mouse hover
local batteryPopup =
  awful.tooltip(
  {
    objects = {batteryIcon},
    mode = "mouse"
  }
)

-- Function to show a notification on low battery
local function showBatteryWarning()
  naughty.notify {
    icon = icons.batteryAlert,
    text = "Your battery is low. Plug your laptop in!",
    title = "Battery low"
  }
end

-- Remember time of last battery check
local last_battery_check = os.time()

-- Watcher to check battery state
watch(
  "acpi -i",
  5,
  function(_, stdout)
    local battery_info = {}
    local capacities = {}

    -- Read every line from 'acpi'
    for s in stdout:gmatch("[^\r\n]+") do
      local status, charge_str, _ = string.match(s, ".+: (%a+), (%d?%d?%d)%%,?.*")
      if status ~= nil then
        -- Line with battery charge (%)
        table.insert(battery_info, {status = status, charge = tonumber(charge_str)})
      else
        -- Line with battery capacity (mAh)
        local cap_str = string.match(s, ".+:.+last full capacity (%d+)")
        table.insert(capacities, tonumber(cap_str))
      end
    end

    -- Calculate correct charge/capacity values
    local capacity = 0
    local charge = 0
    local status
    for _, cap in ipairs(capacities) do
      capacity = capacity + cap
    end
    for i, batt in ipairs(battery_info) do
      if batt.charge >= charge then
        status = batt.status
      end
      charge = charge + batt.charge * capacities[i]
    end
    charge = charge / capacity

    -- Show warn notification if not charging and charge <= 15%
    if (charge >= 0 and charge < 15) then
      if status ~= "Charging" and os.difftime(os.time(), last_battery_check) > 600 then
        -- Show warning every 10 minutes
        last_battery_check = _G.time()
        showBatteryWarning()
      end
    end

    -- Set icon according to the status and charge
    if status == "Charging" or status == "Full" then
      if charge >= 0 and charge < 25 then
        batteryIcon:change_icon(icons.batteryCharging0)
      elseif charge >= 25 and charge < 50 then
        batteryIcon:change_icon(icons.batteryCharging25)
      elseif charge >= 50 and charge < 75 then
        batteryIcon:change_icon(icons.batteryCharging50)
      elseif charge >= 75 and charge < 100 then
        batteryIcon:change_icon(icons.batteryCharging75)
      else
        batteryIcon:change_icon(icons.batteryCharging100)
      end
    else
      if charge >= 0 and charge < 25 then
        batteryIcon:change_icon(icons.battery0)
      elseif charge >= 25 and charge < 50 then
        batteryIcon:change_icon(icons.battery25)
      elseif charge >= 50 and charge < 75 then
        batteryIcon:change_icon(icons.battery50)
      elseif charge >= 75 and charge < 100 then
        batteryIcon:change_icon(icons.battery75)
      else
        batteryIcon:change_icon(icons.battery100)
      end
    end

    -- Update popup text
    batteryPopup.text = string.gsub(stdout, "\n$", "")
    collectgarbage("collect")
  end,
  batteryIcon
)

return batteryIcon
