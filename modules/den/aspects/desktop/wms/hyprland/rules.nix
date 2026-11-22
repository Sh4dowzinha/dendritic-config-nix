{ lib, ... }:
let
  anyOf = patterns: "^(${lib.concatStringsSep "|" patterns})$";

  # General desktop utilities: window class regex -> optional size override (`null` = default)
  floatingApps = {
    "dev\\.noctalia\\.Noctalia" = [
      "monitor_w*0.5625"
      "monitor_h*0.85"
    ];
    "org\\.pulseaudio\\.pavucontrol" = [
      760
      520
    ];
    "blueman-manager" = null;
    "nm-connection-editor" = null;
  };

  floatingSizeRules = lib.mapAttrsToList (class: size: {
    match.class = "^(${class})$";
    inherit size;
  }) (lib.filterAttrs (_: size: size != null) floatingApps);
in
{
  den.aspects.desktop.hyprland = {
    homeManager.wayland.windowManager.hyprland.settings = {
      # Keep workspaces 1–5 alive when empty so Noctalia's workspace indicator always shows them
      workspace_rule = builtins.genList (i: {
        workspace = toString (i + 1);
        persistent = true;
      }) 5;

      layer_rule = [
        # Disable Hyprland layer animations on Noctalia surfaces (Noctalia animates itself)
        {
          name = "noctalia-no-anim";
          match.namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$";
          no_anim = true;
        }
        # Blur Noctalia surfaces and popups
        {
          name = "noctalia-blur";
          match.namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$";
          blur = true;
          blur_popups = true;
          ignore_alpha = 0.5;
        }
        # Crisp screenshot & color-picker overlays
        {
          name = "selection-no-anim";
          match.namespace = anyOf [
            "selection"
            "hyprpicker"
          ];
          no_anim = true;
        }
      ];

      window_rule = lib.mkMerge [
        # =====================================================================
        # 1. Global Safeguards & Selective Blur Baseline (priority 1000)
        # =====================================================================
        [
          {
            name = "suppress-maximize";
            match.class = ".*";
            suppress_event = "maximize";
          }
          {
            name = "fix-xwayland-drags";
            match = {
              xwayland = true;
              class = "^$";
              title = "^$";
            };
            no_focus = true;
          }
          {
            name = "default-no-blur";
            match.class = ".*";
            no_blur = true;
          }
        ]

        # =====================================================================
        # 2. Desktop-Level Tag Assignments (priority 1000)
        #    Individual app aspects also append `tag = "+..."` at priority 1000.
        # =====================================================================
        [
          # Opt-in blur for Noctalia settings and core desktop surfaces
          {
            match.class = anyOf [
              "dev\\.noctalia\\.Noctalia"
              "kitty"
              "foot"
              "org\\.kde\\.dolphin"
            ];
            tag = "+blur";
          }

          # Generic Wayland game content-type hint
          {
            match.content = 3;
            tag = "+games";
          }

          # General desktop utilities
          {
            match.class = anyOf (builtins.attrNames floatingApps);
            tag = "+floating";
          }

          # Portals, polkit prompts, file pickers, and Dolphin progress dialogs
          {
            match.class = anyOf [
              "xdg-desktop-portal-gtk"
              "polkit-gnome-authentication-agent-1"
              "hyprpolkitagent"
              "org\\.freedesktop\\.impl\\.portal\\.desktop\\.kde"
            ];
            tag = "+dialog";
          }
          {
            match.title = "^(${
              lib.concatStringsSep "|" [
                "Open File"
                "Open Folder"
                "Save File"
                "Save As"
                "Select a File"
                "Choose Files"
                "Choose wallpaper"
                "Library"
                "File Upload"
              ]
            })(.*)$";
            tag = "+dialog";
          }
          {
            match = {
              class = "^(org\\.kde\\.dolphin)$";
              title = "^(${
                lib.concatStringsSep "|" [
                  "Copying"
                  "Moving"
                  "Deleting"
                  "File Already Exists"
                  "Progress Dialog"
                ]
              })(.*)$";
            };
            tag = "+dialog";
          }

          # Browser Picture-in-Picture overlays
          {
            match.title = "^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)$";
            tag = "+pip";
          }
        ]

        # =====================================================================
        # 3. Tag Behaviors (priority 1200: runs after all tag assignments,
        #    before any `lib.mkAfter` size/position overrides)
        # =====================================================================
        (lib.mkOrder 1200 [
          {
            name = "tag-blur";
            match.tag = "blur";
            no_blur = false;
          }
          {
            name = "tag-games";
            match.tag = "games";
            opaque = true;
            no_blur = true;
            no_shadow = true;
            no_dim = true;
          }
          {
            name = "tag-crisp";
            match.tag = "crisp";
            opaque = true;
            no_blur = true;
            no_dim = true;
          }
          {
            name = "tag-floating";
            match.tag = "floating";
            float = true;
            center = true;
          }
          {
            name = "tag-dialog";
            match.tag = "dialog";
            float = true;
            center = true;
            size = [
              "monitor_w*0.55"
              "monitor_h*0.65"
            ];
          }
          {
            name = "tag-pip";
            match.tag = "pip";
            float = true;
            pin = true;
            keep_aspect_ratio = true;
            no_dim = true;
            size = [
              "monitor_w*0.25"
              "monitor_h*0.25"
            ];
            move = [
              "monitor_w*0.73"
              "monitor_h*0.72"
            ];
          }
        ])

        # =====================================================================
        # 4. Desktop Utility Size Overrides (priority 1500 via mkAfter)
        # =====================================================================
        (lib.mkAfter floatingSizeRules)
      ];
    };
  };
}
