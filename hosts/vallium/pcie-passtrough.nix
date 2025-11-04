{ config, lib, inputs, host, pkgs, pkgs-stable, pkgs-unstable, pkgs-master, ... }:
{
  boot.initrd.kernelModules = [
    "vfio_pci"
    "vfio"
    "vfio_iommu_type1"
    "kvm-amd"

    # "i915" # replace or remove with your device's driver as needed
   ];
  boot.kernelParams = [
      "amd_iommu=on"
      "vfio-pci.ids=144d:a80a"
    ];
  boot.extraModprobeConfig = "options vfio-pci ids=144d:a80a";
}
