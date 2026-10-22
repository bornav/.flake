{
  inputs,
  config,
  lib,
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

    options kvmfr static_size_mb=128
  '';

  environment.systemPackages = [
    pkgs-stable.looking-glass-client
    pkgs-stable.remmina # XRDP & VNC Client
    # (config.boot.kernelPackages).kvmfr
  ];

  # WORKAROUND — remove once https://github.com/NixOS/nixpkgs/pull/576883 ("kvmfr: signed with .ko.cer")
  # is merged into nixos-unstable (tracks https://github.com/NixOS/nixpkgs/issues/575192).
  # kvmfr's installPhase only installs kvmfr.ko and drops the .ko.cer certificate that
  # aggregateModules now concatenates into modules.cer, so linux-*-modules fails with:
  #   cat: kernel/drivers/misc/kvmfr.ko.cer: No such file or directory  (exit 123)
  # Fix: use the kernel's modules_install (which runs the kmodigest cmd_sign hook) instead of
  # hand-installing the .ko, mirroring the upstream PR.
  boot.extraModulePackages = [
    (let
      kpkgs = config.boot.kernelPackages;
    in
      kpkgs.kvmfr.overrideAttrs (
        old: {
          installPhase = ''
            runHook preInstall

            make -C ${kpkgs.kernel.dev}/lib/modules/${kpkgs.kernel.modDirVersion}/build \
              M=$PWD \
              INSTALL_MOD_PATH=$out \
              ${lib.escapeShellArgs kpkgs.kernelModuleMakeFlags} \
              modules_install

            runHook postInstall
          '';
        }
      ))
  ];

  services.udev.extraRules = ''
    SUBSYSTEM=="kvmfr", GROUP="kvm", MODE="0660", TAG+="uaccess"
  '';
}
