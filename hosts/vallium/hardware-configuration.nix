# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, inputs, vars, modulesPath, ... }:
let
  pkgs-master = import inputs.nixpkgs-master {
    config.allowUnfree = true;
  };
in
{
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];
  boot = {
    initrd.availableKernelModules = [ "nvme" "thunderbolt" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
    initrd.kernelModules = [ ];
    kernelModules = [ "kvm-amd" ];
    # kernelParams = [
    #   "nvidia_drm.fbdev=1"
    # ];# experimental/trmporary, fixes virtualmonitor from poping up on wayland
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

  #nvidia
  hardware = {
    nvidia = {
      modesetting.enable = true;
      open = false;
      nvidiaSettings = true;
      # package = config.boot.kernelPackages.nvidiaPackages.stable;
      # package = config.boot.kernelPackages.nvidiaPackages.production;
      # package = config.boot.kernelPackages.nvidiaPackages.beta;

      # package = lib.mkForce config.boot.kernelPackages.nvidiaPackages.latest; #currently seems to be unused

      package = config.boot.kernelPackages.nvidiaPackages.mkDriver { # how we overwritten the driver
        version = "555.42.02";
        sha256_64bit = "sha256-k7cI3ZDlKp4mT46jMkLaIrc2YUx1lh1wj/J4SVSHWyk=";
        sha256_aarch64 = "sha256-3ae31/egyMKpqtGEqgtikWcwMwfcqMv2K4MVFa70Bqs=";
        openSha256 = "sha256-rtDxQjClJ+gyrCLvdZlT56YyHQ4sbaL+d5tL4L4VfkA=";
        settingsSha256 = "sha256-rtDxQjClJ+gyrCLvdZlT56YyHQ4sbaL+d5tL4L4VfkA=";
        persistencedSha256 = "sha256-3ae31/egyMKpqtGEqgtikWcwMwfcqMv2K4MVFa70Bqs=";
      };

      # forceFullCompositionPipeline = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      # prime = {
      #   offload.enable = true;
      #   #sync.enable = true;
      #   amdgpuBusId = "PCI:108:0:0"; # lspci value, converted hex to decimal
      #   nvidiaBusId = "PCI:1:0:0";
      # };
      # prime = {
      #   # For people who want to use sync instead of offload. Especially for AMD CPU users
      #   sync.enable = lib.mkOverride 990 true;
      #   amdgpuBusId = "";
      #   nvidiaBusId = "";
      # };
    };
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      # extraPackages = with pkgs; [
      # ];
    };
  };
  # environment.systemPackages = with pkgs-unstable; [ linuxKernel.packages.linux_6_8.nvidia_x11 ];

  services.xserver.videoDrivers = ["nvidia"];

}
# (pkgs.linuxPackages_latest.nvidia_x11.overrideAttrs (old: {
#   version = "555.42.02"; # replace with the latest version number
#   src = pkgs.fetchurl {
#     url = "https://us.download.nvidia.com/XFree86/Linux-x86_64/555.42.02/NVIDIA-Linux-x86_64-555.42.02.run";
#     sha256 = "0aavhxa4jy7jixq1v5km9ihkddr2v91358wf9wk9wap5j3fhidwk";
#   };
# })) 