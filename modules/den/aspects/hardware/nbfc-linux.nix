{
  den.aspects.hardware.nbfc-linux = {
    nixos =
      { pkgs, ... }:
      let
        command = "bin/nbfc_service --config-file '/etc/nbfc/nbfc.json'";
      in
      {
        environment.systemPackages = with pkgs; [
          nbfc-linux
        ];

        systemd.services.nbfc_service = {
          enable = true;
          description = "NoteBook FanControl service";
          serviceConfig.Type = "simple";
          path = [ pkgs.kmod ];
          script = "${pkgs.nbfc-linux}/${command}";
          wantedBy = [ "multi-user.target" ];
        };
      };

    persist.files = [
      "/etc/nbfc/nbfc.json"
    ];
  };
}
