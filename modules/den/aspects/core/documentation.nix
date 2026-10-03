{
  den.aspects.core.documentation = {
    os = { pkgs, ... }: {
      environment.systemPackages = [
        pkgs.man-pages
        pkgs.man-pages-posix
      ];
    };

    nixos = {
      documentation = {
        enable = true;
        dev.enable = true;
        doc.enable = true;
        info.enable = true;
        man = {
          enable = true;
          cache = {
            enable = true;
            generateAtRuntime = true;
          };
        };
      };
    };
  };
}
