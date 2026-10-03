{
  den.aspects.core.utils = {
    os = { pkgs, ... }: {
      environment.systemPackages = with pkgs; [
        man-pages
        man-pages-posix
      ];
    };
  };
}
