{
  inputs,
  config,
  pkgs-stable,
  pkgs,
  ...
}: {
  boot.initrd.kernelModules = [
    "vfio"
    "vfio_pci"
    # "vfio_virqfd" # this is not included in vfio so not needed
    "vfio_iommu_type1"
    "kvm-amd"
    # "i915" # replace or remove with your device's driver as needed

    "kvmfr"
  ];
  # boot.initrd.availableKernelModules = ["kvmfr"];
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

    options kvmfr static_size_mb=32
  '';

  environment.systemPackages = [
    pkgs-stable.looking-glass-client
    pkgs-stable.remmina # XRDP & VNC Client
    # (config.boot.kernelPackages).kvmfr
  ];

  boot.extraModulePackages = [
    config.boot.kernelPackages.kvmfr
  ];

  services.udev.extraRules = ''
    SUBSYSTEM=="kvmfr", GROUP="kvm", MODE="0660", TAG+="uaccess"
  '';
}
