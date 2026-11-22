local mod = "SUPER"

local function app(cmd)
  return "app2unit -- " .. cmd
end

local function noctalia(cmd)
  return "noctalia msg " .. cmd
end

-- Core Applications (launched inside UWSM app-graphical.slice)
hl.bind(mod, "T", "exec", app("kitty"))
hl.bind(mod, "W", "exec", app("brave"))
hl.bind(mod, "E", "exec", app("dolphin"))

-- Noctalia Shell Panels & Overlays
hl.bind(mod, "Space", "exec", noctalia("panel-toggle launcher"))
hl.bind(mod, "S", "exec", noctalia("panel-toggle control-center"))
hl.bind(mod .. " SHIFT", "S", "exec", noctalia("panel-toggle control-center system"))
hl.bind(mod, "Comma", "exec", noctalia("settings-toggle"))
hl.bind(mod, "D", "exec", noctalia("dock-toggle"))
hl.bind(mod, "N", "exec", noctalia("notification-clear-active"))
hl.bind(mod .. " SHIFT", "N", "exec", noctalia("notification-dnd-toggle"))

-- Noctalia Alt+Tab Window Switcher
hl.bind("ALT", "Tab", "exec", noctalia("window-switcher hold"))
hl.bind("ALT SHIFT", "Tab", "exec", noctalia("window-switcher hold reverse"))

-- Noctalia Screenshots
hl.bind("", "Print", "exec", noctalia("screenshot-region"))
hl.bind("SHIFT", "Print", "exec", noctalia("screenshot-region --annotate"))
hl.bind(mod, "Print", "exec", noctalia("screenshot-fullscreen"))
hl.bind(mod .. " SHIFT", "Print", "exec", noctalia("screenshot-window"))

-- Noctalia Session & Power
hl.bind(mod, "L", "exec", noctalia("session lock"))
hl.bind(mod .. " SHIFT", "L", "exec", noctalia("session lock-and-suspend"))
hl.bind(mod .. " SHIFT", "E", "exec", noctalia("session logout"))

-- Window Management
hl.bind(mod, "Q", "killactive")
hl.bind(mod, "F", "fullscreen", "0")
hl.bind(mod, "M", "fullscreen", "1")
hl.bind(mod, "V", "togglefloating")
hl.bind(mod, "P", "pseudo")
hl.bind(mod, "J", "togglesplit")

-- Focus & Window Movement (Arrows + Alt-Vim keys so SUPER+L stays free for lock)
local directions = {
  left = "l",
  right = "r",
  up = "u",
  down = "d",
}

for key, dir in pairs(directions) do
  hl.bind(mod, key, "movefocus", dir)
  hl.bind(mod .. " SHIFT", key, "movewindow", dir)
end

hl.bind(mod .. " ALT", "H", "movefocus", "l")
hl.bind(mod .. " ALT", "L", "movefocus", "r")
hl.bind(mod .. " ALT", "K", "movefocus", "u")
hl.bind(mod .. " ALT", "J", "movefocus", "d")

-- Workspaces (1-10)
for i = 1, 10 do
  local key = tostring(i % 10)
  local ws = tostring(i)
  hl.bind(mod, key, "workspace", ws)
  hl.bind(mod .. " SHIFT", key, "movetoworkspace", ws)
end

-- Scratchpad (Special Workspace)
hl.bind(mod, "grave", "togglespecialworkspace", "magic")
hl.bind(mod .. " SHIFT", "grave", "movetoworkspace", "special:magic")

-- Scroll Through Workspaces
hl.bind(mod, "mouse_down", "workspace", "e+1")
hl.bind(mod, "mouse_up", "workspace", "e-1")

-- Mouse Move / Resize
hl.bindm(mod, "mouse:272", "movewindow")
hl.bindm(mod, "mouse:273", "resizewindow")

-- Repeatable Hardware Keys (work even when locked)
hl.bindel("", "XF86AudioRaiseVolume", "exec", noctalia("volume-up"))
hl.bindel("", "XF86AudioLowerVolume", "exec", noctalia("volume-down"))
hl.bindel("", "XF86MonBrightnessUp", "exec", noctalia("brightness-up"))
hl.bindel("", "XF86MonBrightnessDown", "exec", noctalia("brightness-down"))

-- Single-Press Hardware Keys (work even when locked)
hl.bindl("", "XF86AudioMute", "exec", noctalia("volume-mute"))
hl.bindl("", "XF86AudioMicMute", "exec", noctalia("mic-mute"))
hl.bindl("", "XF86AudioPlay", "exec", noctalia("media play-pause"))
hl.bindl("", "XF86AudioNext", "exec", noctalia("media next"))
hl.bindl("", "XF86AudioPrev", "exec", noctalia("media previous"))
