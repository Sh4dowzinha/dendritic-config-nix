local mod = "SUPER"

local function app(cmd)
  return hl.dsp.exec_cmd("app2unit -- " .. cmd)
end

local function noctalia(cmd)
  return hl.dsp.exec_cmd("noctalia msg " .. cmd)
end

-- Core Applications (launched inside UWSM app-graphical.slice)
hl.bind(mod .. " + T", app("kitty"))
hl.bind(mod .. " + W", app("brave-origin"))
hl.bind(mod .. " + E", app("dolphin"))

-- Noctalia Shell Panels & Overlays
hl.bind(mod .. " + Space", noctalia("panel-toggle launcher"))
hl.bind(mod .. " + S", noctalia("panel-toggle control-center"))
hl.bind(mod .. " + SHIFT + S", noctalia("panel-toggle control-center system"))
hl.bind(mod .. " + comma", noctalia("settings-toggle"))
hl.bind(mod .. " + D", noctalia("dock-toggle"))
hl.bind(mod .. " + N", noctalia("notification-clear-active"))
hl.bind(mod .. " + SHIFT + N", noctalia("notification-dnd-toggle"))

-- Noctalia Alt+Tab Window Switcher
hl.bind("ALT + Tab", noctalia("window-switcher hold"))
hl.bind("ALT + SHIFT + Tab", noctalia("window-switcher hold reverse"))

-- Noctalia Screenshots
hl.bind("Print", noctalia("screenshot-region"))
hl.bind("SHIFT + Print", noctalia("screenshot-region --annotate"))
hl.bind(mod .. " + Print", noctalia("screenshot-fullscreen"))
hl.bind(mod .. " + SHIFT + Print", noctalia("screenshot-window"))

-- Noctalia Session & Power
hl.bind(mod .. " + L", noctalia("session lock"))
hl.bind(mod .. " + SHIFT + L", noctalia("session lock-and-suspend"))
hl.bind(mod .. " + SHIFT + E", noctalia("session logout"))

-- Window Management
hl.bind(mod .. " + Q", hl.dsp.window.close())
hl.bind(mod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind(mod .. " + M", hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(mod .. " + V", hl.dsp.window.float())
hl.bind(mod .. " + P", hl.dsp.window.pseudo())
hl.bind(mod .. " + J", hl.dsp.layout("togglesplit"))

-- Focus & Window Movement (Arrows + Alt-Vim keys so SUPER+L stays free for lock)
for _, dir in ipairs({ "left", "right", "up", "down" }) do
  hl.bind(mod .. " + " .. dir, hl.dsp.focus({ direction = dir }))
  hl.bind(mod .. " + SHIFT + " .. dir, hl.dsp.window.move({ direction = dir }))
end

hl.bind(mod .. " + ALT + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + ALT + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + ALT + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + ALT + J", hl.dsp.focus({ direction = "down" }))

-- Workspaces (1-10)
for i = 1, 10 do
  local key = tostring(i % 10)
  local ws = tostring(i)
  hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = ws }))
  hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = ws, follow = true }))
end

-- Scratchpad (Special Workspace)
hl.bind(mod .. " + grave", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mod .. " + SHIFT + grave", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll Through Workspaces
hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Mouse Drag / Resize
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Repeatable Hardware Keys (active even when locked)
hl.bind("XF86AudioRaiseVolume", noctalia("volume-up"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", noctalia("volume-down"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", noctalia("brightness-up"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", noctalia("brightness-down"), { locked = true, repeating = true })

-- Single-Press Hardware Keys (active even when locked)
hl.bind("XF86AudioMute", noctalia("volume-mute"), { locked = true })
hl.bind("XF86AudioMicMute", noctalia("mic-mute"), { locked = true })
hl.bind("XF86AudioPlay", noctalia("media toggle"), { locked = true })
hl.bind("XF86AudioNext", noctalia("media next"), { locked = true })
hl.bind("XF86AudioPrev", noctalia("media previous"), { locked = true })
