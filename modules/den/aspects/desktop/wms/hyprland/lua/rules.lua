-- Noctalia Settings
hl.window_rule({
    match = { class = "dev.noctalia.Noctalia" },
    float = true,
    size = "monitor_w*0.5625 monitor_h*0.85",
})

hl.layer_rule({
  name = "noctalia-no-anim",
  match = {
    namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$",
  },
  no_anim = true,
})

hl.layer_rule({
  name = "noctalia-blur",
  match = {
    namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$",
  },
  ignore_alpha = 0.5,
  blur = true,
  blur_popups = true,
})
