{ lib, ... }:
{
  den.aspects.core.localization.i18n = {
    nixos = { host, pkgs, ... }: {
      i18n.defaultLocale = "en_US.UTF-8";
      i18n.extraLocales = [ "pt_PT.UTF-8/UTF-8" ];

      i18n.extraLocaleSettings = {
        LC_ADDRESS = "pt_PT.UTF-8";
        LC_IDENTIFICATION = "pt_PT.UTF-8";
        LC_MEASUREMENT = "pt_PT.UTF-8";
        LC_MONETARY = "pt_PT.UTF-8";
        LC_NAME = "pt_PT.UTF-8";
        LC_NUMERIC = "en_US.UTF-8";
        LC_PAPER = "pt_PT.UTF-8";
        LC_TELEPHONE = "pt_PT.UTF-8";
        LC_TIME = "pt_PT.UTF-8";
      };

      console = {
        keyMap = host.keyboard.layout or "us";
        font = lib.mkDefault "Lat2-Terminus16";
        earlySetup = true;
        packages = with pkgs; [
          terminus_font
        ];
      };
    };
  };
}
