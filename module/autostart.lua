local awful = require("awful")
local apps = require("configuration.apps")

-- Function to start an application if it is not already running
local function spawnOnce(cmd)
  local findme = cmd
  local firstspace = cmd:find(" ")
  if firstspace then
    findme = cmd:sub(0, firstspace - 1)
  end
  awful.spawn.with_shell(string.format("pgrep -u $USER -x %s > /dev/null || (%s)", findme, cmd))
end

-- Function to start an application which is not running on the specified tag
local function spawnOnceOnTag(command, class, tag)
  local callback
  callback = function(c)
    if c.class == class then
      c:move_to_tag(tag)
      _G.client.disconnect_signal("manage", callback)
    end
  end
  _G.client.connect_signal("manage", callback)
  spawnOnce(command)
end

-- Start daemons
for _, app in ipairs(apps.daemons) do
  spawnOnce(app)
end

-- Start user applications
for _, app in ipairs(apps.userApps) do
  local tag = _G.getTagFromName(app.tag)
  spawnOnceOnTag(app.command, app.class, tag)
end
