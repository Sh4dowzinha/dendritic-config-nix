# Home-manager NixOS module configuration.
# Den's home-manager battery handles importing the HM NixOS module itself.
# This aspect sets shared config (useGlobalPkgs, useUserPackages, sharedModules).
{ lib, ... }:
{
  den.aspects.core.users.home-manager-shared = {
    settings.useGlobalPkgs = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Home-manager shares the host's nixpkgs — its overlays and config — instead
        of evaluating its own pkgs set. User-declared overlays project to the host
        (see the nixpkgs-overlays quirk); when false each user's home-manager
        collects its own overlays independently.
      '';
    };

    nixos =
      {
        pkgs,
        host,
        inputs',
        self',
        ...
      }:
      {
        home-manager = {
          useGlobalPkgs = host.settings.core.users.home-manager-shared.useGlobalPkgs;
          useUserPackages = true;
          backupCommand = lib.getExe' pkgs.trash-cli "trash-put";

          extraSpecialArgs = {
            inherit inputs' self';
          };

          sharedModules = [
            (
              { osConfig, ... }:
              {
                programs.home-manager.enable = true;
                home.enableNixpkgsReleaseCheck = true;
                home.stateVersion = osConfig.system.stateVersion;
                systemd.user.startServices = "sd-switch";
              }
            )
          ];
        };
      };

    homeManager =
      { homeManagerModules, ... }:
      {
        imports = homeManagerModules;
      };
  };
}
