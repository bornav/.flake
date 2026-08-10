{...}: {
  boot.initrd.kernelModules = [
    "vfio"
    "vfio_pci"
    # "vfio_virqfd" # this is not included in vfio so not needed
    "vfio_iommu_type1"
    "kvm-amd"

    # "i915" # replace or remove with your device's driver as needed
  ];
  boot.kernelParams = [
    "amd_iommu=on"
    "iommu=pt"
    "vfio-pci.ids=144d:a804,1002:164e,1002:1640"
  ];
  boot.extraModprobeConfig = ''
    softdep radeon pre: vfio-pci
    softdep amdgpu pre: vfio-pci
    softdep snd_hda_intel pre: vfio-pci
    options vfio_iommu_type1 allow_unsafe_interrupts=1
  '';
  #   options vfio-pci ids=144d:a80a
  #   options vfio-pci ids=1002:164e,1002:1640

  #   softdep radeon pre: vfio-pci
  #   softdep amdgpu pre: vfio-pci
  #   softdep snd_hda_intel pre: vfio-pci
  # '';
  # boot.blacklistedKernelModules = ["amdgpu" "radeon"];
}
