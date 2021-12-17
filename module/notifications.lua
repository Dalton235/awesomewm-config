local naughty = require("naughty")
local dpi = require("beautiful").xresources.apply_dpi

-- Configure naughty
naughty.config.padding = dpi(32)
naughty.config.spacing = dpi(8)

naughty.config.defaults.timeout = 10
naughty.config.defaults.screen = 1
naughty.config.defaults.ontop = true
naughty.config.defaults.margin = dpi(16)
naughty.config.defaults.border_width = 0
naughty.config.defaults.position = "bottom_left"
naughty.config.defaults.font = "Roboto Regular 10"
naughty.config.defaults.hover_timeout = nil
naughty.config.defaults.icon_size = dpi(48)

-- Check for startup errors and notify the user
if _G.awesome.startup_errors then
  naughty.notify(
    {
      preset = naughty.config.presets.critical,
      title = "AwesomeWM startup errors!",
      text = _G.awesome.startup_errors
    }
  )
end

-- Endless loop checking for runtime errors and notifying the user
do
  local in_error = false
  _G.awesome.connect_signal(
    "debug::error",
    function(err)
      if in_error then
        return
      end
      in_error = true

      naughty.notify(
        {
          preset = naughty.config.presets.critical,
          title = "AwesomeWM runtime error!",
          text = tostring(err)
        }
      )
      in_error = false
    end
  )
end

-- Debug function to show somethin on the screen
_G.log_this = function(title, txt)
  naughty.notify(
    {
      title = "log: " .. title,
      text = txt
    }
  )
end
