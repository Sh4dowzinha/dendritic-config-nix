{
  den.aspects.zram.nixos = {
    zramSwap = {
      enable = true;
      priority = 100;
      algorithm = "zstd";
      memoryPercent = 50;
    };
  };
}
