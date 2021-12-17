local awful = require("awful")
local tyrannical = require("tyrannical")
local defaultApps = require("configuration.apps").default
local keybindsHelp = require("awful.hotkeys_popup").widget

local modKey = "Mod4"
local altKey = "Mod1"

-- Function to move a client across multiple screens
local function moveClient(c, dir)
  awful.client.focus.bydirection(dir)
  local next_c = _G.client.focus
  -- Check if client is "dir"-most client
  if c == next_c then
    -- Move client to "dir" screen if a screen is present
    local next_s = c.screen:get_next_in_direction(dir)
    if next_s then
      c:move_to_screen(next_s.index)
    end
  else
    -- Reset focus to original client and swap it
    _G.client.focus = c
    awful.client.swap.bydirection(dir)
  end
end

-- Define globally avaiable keybindings
local keybinds =
  awful.util.table.join(
  -- General
  awful.key({modKey}, "F1", keybindsHelp.show_help, {description = "Show keybindings", group = "1. General"}),
  awful.key({modKey, "Control"}, "r", _G.awesome.restart, {description = "Reload Awesome", group = "1. General"}),
  awful.key(
    {modKey},
    "Escape",
    function()
      _G.exit_screen_show()
    end,
    {description = "Exit menu", group = "1. General"}
  ),
  awful.key(
    {},
    "Print",
    function()
      awful.util.spawn_with_shell("maim -s | xclip -selection clipboard -t image/png")
    end,
    {description = "Region screenshot to clipboard", group = "1. General"}
  ),
  -- Tag
  awful.key(
    {modKey},
    "Tab",
    function()
      awful.layout.inc(1)
    end,
    {description = "Change layout", group = "2. Tag"}
  ),
  awful.key(
    {modKey, "Shift"},
    "a",
    function()
      local props = tyrannical.tags_by_name["empty"]
      props.screen = _G.screen.focused
      local t = awful.tag.add("empty", props)
      awful.tag.viewonly(t)
    end,
    {description = "Add empty tag", group = "2. Tag"}
  ),
  awful.key(
    {modKey, "Shift"},
    "r",
    function()
      local t = awful.screen.focused().selected_tag
      t:delete()
    end,
    {description = "Remove tag", group = "2. Tag"}
  ),
  -- Client
  awful.key(
    {modKey},
    "Left",
    function()
      awful.client.focus.global_bydirection("left")
    end,
    {description = "Focus client left", group = "3. Client"}
  ),
  awful.key(
    {modKey},
    "Down",
    function()
      awful.client.focus.global_bydirection("down")
    end,
    {description = "Focus client down", group = "3. Client"}
  ),
  awful.key(
    {modKey},
    "Up",
    function()
      awful.client.focus.global_bydirection("up")
    end,
    {description = "Focus client up", group = "3. Client"}
  ),
  awful.key(
    {modKey},
    "Right",
    function()
      awful.client.focus.global_bydirection("right")
    end,
    {description = "Focus client right", group = "3. Client"}
  ),
  awful.key(
    {modKey},
    "h",
    function()
      awful.client.focus.global_bydirection("left")
    end,
    {description = "Focus client left", group = "3. Client"}
  ),
  awful.key(
    {modKey},
    "j",
    function()
      awful.client.focus.global_bydirection("down")
    end,
    {description = "Focus client down", group = "3. Client"}
  ),
  awful.key(
    {modKey},
    "k",
    function()
      awful.client.focus.global_bydirection("up")
    end,
    {description = "Focus client up", group = "3. Client"}
  ),
  awful.key(
    {modKey},
    "l",
    function()
      awful.client.focus.global_bydirection("right")
    end,
    {description = "Focus client right", group = "3. Client"}
  ),
  awful.key(
    {modKey, "Shift"},
    "Left",
    function()
      moveClient(_G.client.focus, "left")
    end,
    {description = "Move client left", group = "3. Client"}
  ),
  awful.key(
    {modKey, "Shift"},
    "Down",
    function()
      moveClient(_G.client.focus, "down")
    end,
    {description = "Move client down", group = "3. Client"}
  ),
  awful.key(
    {modKey, "Shift"},
    "Up",
    function()
      moveClient(_G.client.focus, "up")
    end,
    {description = "Move client up", group = "3. Client"}
  ),
  awful.key(
    {modKey, "Shift"},
    "Right",
    function()
      moveClient(_G.client.focus, "right")
    end,
    {description = "Move client right", group = "3. Client"}
  ),
  awful.key(
    {modKey, "Shift"},
    "h",
    function()
      moveClient(_G.client.focus, "left")
    end,
    {description = "Move client left", group = "3. Client"}
  ),
  awful.key(
    {modKey, "Shift"},
    "j",
    function()
      moveClient(_G.client.focus, "down")
    end,
    {description = "Move client down", group = "3. Client"}
  ),
  awful.key(
    {modKey, "Shift"},
    "k",
    function()
      moveClient(_G.client.focus, "up")
    end,
    {description = "Move client up", group = "3. Client"}
  ),
  awful.key(
    {modKey, "Shift"},
    "l",
    function()
      moveClient(_G.client.focus, "right")
    end,
    {description = "Move client right", group = "3. Client"}
  ),
  awful.key(
    {modKey, "Control"},
    "Left",
    function()
      awful.tag.incmwfact(-0.05)
    end,
    {description = "Resize client left", group = "3. Client"}
  ),
  awful.key(
    {modKey, "Control"},
    "Down",
    function()
      awful.client.incwfact(-0.1)
    end,
    {description = "Resize client down", group = "3. Client"}
  ),
  awful.key(
    {modKey, "Control"},
    "Up",
    function()
      awful.client.incwfact(0.1)
    end,
    {description = "Resize client up", group = "3. Client"}
  ),
  awful.key(
    {modKey, "Control"},
    "Right",
    function()
      awful.tag.incmwfact(0.05)
    end,
    {description = "Resize client right", group = "3. Client"}
  ),
  awful.key(
    {modKey, "Control"},
    "h",
    function()
      awful.tag.incmwfact(-0.05)
    end,
    {description = "Resize client left", group = "3. Client"}
  ),
  awful.key(
    {modKey, "Control"},
    "j",
    function()
      awful.client.incwfact(-0.1)
    end,
    {description = "Resize client down", group = "3. Client"}
  ),
  awful.key(
    {modKey, "Control"},
    "k",
    function()
      awful.client.incwfact(0.1)
    end,
    {description = "Resize client up", group = "3. Client"}
  ),
  awful.key(
    {modKey, "Control"},
    "l",
    function()
      awful.tag.incmwfact(0.05)
    end,
    {description = "Resize client right", group = "3. Client"}
  ),
  awful.key(
    {modKey},
    "f",
    function()
      local c = _G.client.focus
      if c then
        c.fullscreen = not c.fullscreen
        c:raise()
      end
    end,
    {description = "Fullscreen", group = "3. Client"}
  ),
  awful.key(
    {modKey},
    "q",
    function()
      local c = _G.client.focus
      if c then
        c:kill()
      end
    end,
    {description = "Close", group = "3. Client"}
  ),
  -- Launcher
  awful.key(
    {modKey},
    "d",
    function()
      awful.screen.focused().topPanel:run_rofi()
    end,
    {description = "Rofi", group = "4. Launcher"}
  ),
  awful.key(
    {modKey},
    "x",
    function()
      awful.spawn(defaultApps.terminal)
    end,
    {description = "Terminal", group = "4. Launcher"}
  ),
  awful.key(
    {modKey},
    "m",
    function()
      awful.util.spawn_with_shell(defaultApps.terminal .. " alsamixer")
    end,
    {description = "AlsaMixer", group = "4. Launcher"}
  ),
  -- ALSA volume control
  awful.key(
    {},
    "XF86AudioRaiseVolume",
    function()
      awful.spawn("amixer sset Master 5%+")
    end
  ),
  awful.key(
    {},
    "XF86AudioLowerVolume",
    function()
      awful.spawn("amixer sset Master 5%-")
    end
  ),
  awful.key(
    {},
    "XF86AudioMute",
    function()
      awful.spawn("amixer sset Master toggle")
    end
  )
)

-- Bind key numbers to tags
for i = 1, 9 do
  -- Hack to only show tags 1 and 9 in keybindings help menu
  local descr_view, descr_toggle, descr_move
  if i == 1 or i == 9 then
    descr_view = {description = "Jump to tag #", group = "2. Tag"}
    descr_toggle = {description = "Toggle tag #", group = "2. Tag"}
    descr_move = {description = "Move focused client to tag #", group = "2. Tag"}
  end

  keybinds =
    awful.util.table.join(
    keybinds,
    awful.key(
      {modKey},
      "#" .. i + 9,
      function()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
          tag:view_only()
        end
      end,
      descr_view
    ),
    awful.key(
      {modKey, "Control"},
      "#" .. i + 9,
      function()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
          awful.tag.viewtoggle(tag)
        end
      end,
      descr_toggle
    ),
    awful.key(
      {modKey, "Shift"},
      "#" .. i + 9,
      function()
        if _G.client.focus then
          local tag = _G.client.focus.screen.tags[i]
          if tag then
            _G.client.focus:move_to_tag(tag)
          end
        end
      end,
      descr_move
    )
  )
end

return {
  modKey = modKey,
  altKey = altKey,
  keybinds = keybinds
}
