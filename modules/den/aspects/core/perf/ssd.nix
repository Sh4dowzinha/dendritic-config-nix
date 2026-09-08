# ssd — SSD fstrim service.
{
  den.aspects.core.perf.ssd = {
    nixos = {
      services.fstrim = {
        enable = true;
        interval = "weekly";
      };
    };
  };
}
