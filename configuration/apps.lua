local filesystem = require("gears.filesystem")

return {
  -- List of default applications
  default = {
    terminal = "kitty",
    editor = "nvim",
    browser = "firefox",
    rofi = "rofi -show drun -modi drun,run,window -theme " ..
      filesystem.get_configuration_dir() .. "/configuration/rofi.rasi -m ",
    lock = "dm-tool lock"
  },
  -- List of daemons to start once on login
  daemons = {
    "compton --config " .. filesystem.get_configuration_dir() .. "/configuration/compton.conf",
    "udiskie",
    "xfce4-power-manager", -- Power manager
    "numlockx on",
    "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 && eval $(gnome-keyring-daemon -s --components=pkcs11,secrets,ssh,gpg)" -- credential manager
  },
  -- List of user applications to start on login
  userApps = {
    {
      command = "firefox",
      class = "Firefox",
      tag = "browser"
    },
    {
      command = "spotify --force-device-scale-factor=2",
      class = "Spotify",
      tag = "music"
    },
    {
      command = "kitty",
      class = "kitty",
      tag = "terminal"
    },
    {
      command = "keepassxc",
      class = "keepassxc",
      tag = "password"
    },
    {
      command = "pidgin",
      class = "Pidgin",
      tag = "messenger"
    },
    {
      command = "code-oss",
      class = "code-oss",
      tag = "code"
    }
  }
}
