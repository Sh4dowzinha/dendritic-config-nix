{
  den.aspects.core.security = {
    nixos =
      { pkgs, ... }:
      {
        security.polkit.enable = true;

        security.tpm2 = {
          enable = true;
        };

        services.pcscd.enable = true;
      };

    persist = {
      directories = [
        {
          directory = "/var/lib/swtpm";
          user = "tss";
          group = "tss";
          mode = "0750";
        }
        {
          directory = "/var/lib/swtpm-localca";
          user = "tss";
          group = "tss";
          mode = "0750";
        }
      ];
    };
  };
}
