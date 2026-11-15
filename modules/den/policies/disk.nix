{
  den,
  lib,
  ...
}:
let
  inherit (den.lib.policy) include;
in
{
  den.policies.auto-include-disk =
    { host, ... }:
    let
      diskAspects = den.aspects.disk or { };

      # Only layout aspects that declare `settings` are selectable via host.settings.disk.*
      # (excludes shared base aspects like `disk.btrfs`).
      selectableDisks = lib.filterAttrs (_: aspect: aspect ? settings) diskAspects;

      isConfigured =
        name: aspect:
        let
          actual = host.settings.disk.${name} or { };
          defaults = lib.mapAttrs (_: opt: opt.default or null) aspect.settings;
        in
        actual != defaults;

      configuredNames = builtins.attrNames (lib.filterAttrs isConfigured selectableDisks);

      selectedDiskAspects =
        assert lib.assertMsg (builtins.length configuredNames <= 1)
          "Host '${host.name}' configures multiple disk layouts in settings.disk: ${toString configuredNames}. Configure only one.";
        if configuredNames != [ ] then
          map (name: selectableDisks.${name}) configuredNames
        else if selectableDisks ? btrfs-single then
          [ selectableDisks.btrfs-single ]
        else
          [ ];
    in
    lib.optional (selectedDiskAspects != [ ]) (include {
      includes = selectedDiskAspects;
    });

  den.schema.host.includes = [
    den.policies.auto-include-disk
  ];
}
