{
  den.aspects.hardware.cpu.intel = {
    nixos = {
      hardware.cpu.intel.updateMicrocode = true;
      boot.kernelModules = [ "kvm-intel" ];
      boot.kernelParams = [ "intel_iommu=on" "iommu=pt" ];
      services.thermald.enable = true;
    };
  };
}
