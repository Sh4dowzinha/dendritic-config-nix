{
  den.aspects.core.system.appimage = {
    nixos = {
      programs.appimage = {
        enable = true;
        binfmt = true;
      };
    };
  };
}
