{
  den.aspects.core.security = {
    nixos = {
      security.polkit.enable = true;
      security.polkit.enablePkexecWrapper = true;

      security.tpm2 = {
        enable = true;
      };
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
