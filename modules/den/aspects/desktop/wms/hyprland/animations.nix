let
  mkBezier = name: p1: p2: {
    _args = [
      name
      {
        type = "bezier";
        points = [
          p1
          p2
        ];
      }
    ];
  };
in
{
  den.aspects.desktop.hyprland = {
    homeManager.wayland.windowManager.hyprland.settings = {
      config.animations.enabled = true;

      # end-4 Material 3 Expressive Bézier curves
      curve = [
        (mkBezier "expressiveFastSpatial" [ 0.42 1.67 ] [ 0.21 0.90 ])
        (mkBezier "expressiveSlowSpatial" [ 0.39 1.29 ] [ 0.35 0.98 ])
        (mkBezier "expressiveDefaultSpatial" [ 0.38 1.21 ] [ 0.22 1.00 ])
        (mkBezier "emphasizedDecel" [ 0.05 0.7 ] [ 0.1 1 ])
        (mkBezier "emphasizedAccel" [ 0.3 0 ] [ 0.8 0.15 ])
        (mkBezier "standardDecel" [ 0 0 ] [ 0 1 ])
        (mkBezier "menu_decel" [ 0.1 1 ] [ 0 1 ])
        (mkBezier "menu_accel" [ 0.38 0.04 ] [ 1 0.07 ])
        (mkBezier "stall"
          [
            1
            (-0.1)
          ]
          [ 0.7 0.85 ]
        )
      ];

      animation = [
        # Windows
        {
          leaf = "windowsIn";
          enabled = true;
          speed = 3;
          curve = "emphasizedDecel";
          style = "popin 80%";
        }
        {
          leaf = "fadeIn";
          enabled = true;
          speed = 3;
          curve = "emphasizedDecel";
        }
        {
          leaf = "windowsOut";
          enabled = true;
          speed = 2;
          curve = "emphasizedDecel";
          style = "popin 90%";
        }
        {
          leaf = "fadeOut";
          enabled = true;
          speed = 2;
          curve = "emphasizedDecel";
        }
        {
          leaf = "windowsMove";
          enabled = true;
          speed = 3;
          curve = "emphasizedDecel";
          style = "slide";
        }
        {
          leaf = "border";
          enabled = true;
          speed = 10;
          curve = "emphasizedDecel";
        }

        # Layers (Noctalia surfaces override this with no_anim = true in rules.nix)
        {
          leaf = "layersIn";
          enabled = true;
          speed = 2.7;
          curve = "emphasizedDecel";
          style = "popin 93%";
        }
        {
          leaf = "layersOut";
          enabled = true;
          speed = 2.4;
          curve = "menu_accel";
          style = "popin 94%";
        }
        {
          leaf = "fadeLayersIn";
          enabled = true;
          speed = 0.5;
          curve = "menu_decel";
        }
        {
          leaf = "fadeLayersOut";
          enabled = true;
          speed = 2.7;
          curve = "stall";
        }

        # Workspaces
        {
          leaf = "workspaces";
          enabled = true;
          speed = 3;
          curve = "menu_decel";
          style = "slide";
        }
        {
          leaf = "specialWorkspaceIn";
          enabled = true;
          speed = 2.8;
          curve = "emphasizedDecel";
          style = "slidevert";
        }
        {
          leaf = "specialWorkspaceOut";
          enabled = true;
          speed = 1.2;
          curve = "emphasizedAccel";
          style = "slidevert";
        }
      ];
    };
  };
}
