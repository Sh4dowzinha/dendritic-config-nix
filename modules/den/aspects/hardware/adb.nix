{
  den.aspects.hardware.adb = {
    nixos =
      {
        pkgs,
        resolved-users,
        lib,
        ...
      }:
      {
        environment.systemPackages = with pkgs; [
          android-file-transfer
          android-tools
        ];

        users.users = lib.genAttrs (map (u: u.name) resolved-users) (_: {
          extraGroups = [ "adbusers" ];
        });
      };
  };
}
