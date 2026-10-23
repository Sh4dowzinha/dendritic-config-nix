{
  den.aspects.applications.media.stremio = {
    homeManager = { pkgs, ... }: {
      home.packages = [ pkgs.stremio-linux-shell ];
    };
  };
}
