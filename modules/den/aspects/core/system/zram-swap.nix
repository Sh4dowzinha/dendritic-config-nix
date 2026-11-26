{ lib, ... }:
{
  den.aspects.core.system.zram-swap = {
    nixos = {
      zramSwap = {
        enable = true;
        # zram pages live in RAM; keep the cap modest so reclaiming into it
        # remains a net headroom win under memory pressure.
        memoryPercent = lib.mkDefault 25;
      };

      # Zero-seek zram works best with single-page swap-in and proactive
      # anonymous page compression.
      boot.kernel.sysctl = {
        "vm.page-cluster" = lib.mkDefault 0;
        "vm.swappiness" = lib.mkDefault 100;
      };

      # Prevent a single task from freezing the system without relying solely
      # on the kernel OOM killer's heuristics.
      services.earlyoom = {
        enable = true;

        # With zram as the only swap, pin both swap arms at 100% so the policy
        # is purely memory-driven. Hosts with disk swap can override via mkDefault.
        freeSwapThreshold = lib.mkDefault 100;
        freeSwapKillThreshold = lib.mkDefault 100;

        freeMemThreshold = lib.mkDefault 5;
        freeMemKillThreshold = lib.mkDefault 2;
      };
    };
  };
}
