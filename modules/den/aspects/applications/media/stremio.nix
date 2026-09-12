{
  den.aspects.applications.media.stremio = {
    homeLinux = { pkgs, ... }: {
      home.packages = [ pkgs.stremio-linux-shell ];
    };
  };
}
