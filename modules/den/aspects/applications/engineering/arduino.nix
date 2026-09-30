{
  den.aspects.applications.engineering.arduino = {
    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [
        arduino-ide
      ];
    };
  };
}
