{
  den.aspects.hardware.cpu.amd = {
    nixos = _: {
      hardware.cpu.amd.updateMicrocode = true;
      boot.kernelModules = [ "kvm-amd" ];
      boot.kernelParams = [ "iommu=pt" ];
    };
  };
}
