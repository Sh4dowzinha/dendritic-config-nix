{
  den.aspects.hardware.adb = {
    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          android-file-transfer
          android-tools
        ];
      };
  };
}
