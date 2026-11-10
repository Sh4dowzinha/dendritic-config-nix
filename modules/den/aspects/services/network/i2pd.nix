{
  den.aspects.services.network.i2pd = {
    nixos = { lib, ... }: {
      services.i2pd = {
        enable = true;
        settings = {

          # Network transports
          ipv4 = true;
          ipv6 = true;
          bandwidth = "O"; # ~256 KB/s transit limit

          # UPnP disabled by default
          upnp.enabled = false;

          # Web Console (127.0.0.1:7070)
          http = {
            enabled = true;
            address = "127.0.0.1";
            port = 7070;
          };

          # HTTP Proxy
          httpproxy = {
            enabled = true;
            address = "127.0.0.1";
            port = 4444;
          };

          # SOCKS proxy
          socksproxy = {
            enabled = true;
            address = "127.0.0.1";
            port = 4447;
          };

          sam.enabled = false;
          bob.enabled = false;
          i2cp.enabled = false;
          i2pcontrol.enabled = false;

          precomputation.elgamal = true;
        };
      };

      # Prevent systemd from starting i2pd during boot
      systemd.services.i2pd.wantedBy = lib.mkForce [ ];

      # Allow members of wheel to start/stop i2pd without entering sudo password
      security.polkit.extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (action.id == "org.freedesktop.systemd1.manage-units" &&
              action.lookup("unit") == "i2pd.service" &&
              subject.isInGroup("wheel")) {
            return polkit.Result.YES;
          }
        });
      '';
    };

    homeManager = _: {
      home.shellAliases = {
        i2pon = "systemctl start i2pd.service && echo 'i2pd started (warming up tunnels...)'";
        i2poff = "systemctl stop i2pd.service && echo 'i2pd stopped'";
        i2pstatus = "systemctl status i2pd.service";
      };
    };

    persist.directories = [
      {
        directory = "/var/lib/private/i2pd";
        mode = "0700";
      }
    ];
  };
}
