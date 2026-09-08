{ inputs, ... }:
{
  den.aspects.hardware.cpu.amd = {
    nixos =
      { config, pkgs, ... }:
      {

        environment.systemPackages = [ pkgs.amdctl ];

        boot = {
          kernelModules = [
            "kvm-amd"
            "msr"
          ];
          kernelParams = [
            "smt=on"
            "amd_iommu=on"
            "iommu=pt"
            "iomem=relaxed"
            "amd_pstate=active"
          ];
        };

        # amd_pstate=active hands frequency selection to the firmware via EPP
        # and offers only performance|powersave, so the schedutil/ondemand
        # defaults other aspects request are dropped without a warning and the
        # host silently lands on powersave anyway. State the reachable governor
        # where the restriction originates; a plain assignment outranks their
        # mkDefault. Anything wanting a governor-driven policy (including
        # scx's --cpufreq) has to move this host off active mode first.
        powerManagement.cpuFreqGovernor = "powersave";
        hardware.cpu.amd.updateMicrocode = true;
      };
  };
}
