# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ lib, modulesPath, ... }:
let
in
{
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];
  boot = {
    initrd.availableKernelModules = [ "nvme" "thunderbolt" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
    initrd.kernelModules = [ "nvidia" ];
    kernelModules = [ "kvm-amd" ];
    kernelParams = [
      "nvidia_drm.nvidia_modeset"
      "nvidia_drm.fbdev=1"
    ];# experimental/trmporary, fixes virtualmonitor from poping up on wayland
    extraModulePackages = [ ];
    blacklistedKernelModules = ["amdgpu"];
  };

  fileSystems."/" =
    { device = "/dev/disk/by-label/NIXOS";
      fsType = "ext4";
      options = [
        "noatime"
      ];
    };
  fileSystems."/boot" =
    { device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
    };
  fileSystems."/home" =
    { device = "/dev/disk/by-label/home_partition";
      fsType = "ext4";
      options = [
        "noatime"
      ];
    };
  # fileSystems."/home/${vars.user}/.share/ssd_ext4" =
  fileSystems."/mnt/ssd_ext4" =
    { device = "/dev/disk/by-label/ssd_ext4";
      fsType = "ext4";
      options = [
        # "user"
        "rw"
        "noatime"
        "relatime"
        "x-systemd.automount"
        "x-systemd.idle-timeout=60"
        "x-systemd.device-timeout=5s"
        "x-systemd.mount-timeout=5s"
      ];
    };

  # services.fstrim.enable = lib.mkDefault true;
  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno2.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp8s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
