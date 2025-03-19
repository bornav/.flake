{ config, lib, inputs, host, pkgs, pkgs-stable, pkgs-unstable, pkgs-master, ... }:
{
  imports = [
      inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
  ];
  #nvidia
  boot = {
    initrd.kernelModules = [ "nvidia" ];
    kernelParams = [
      "nomodeset"
      "nvidia_drm.nvidia_modeset"
      "nvidia_drm.fbdev=1"
    ];# experimental/trmporary, fixes virtualmonitor from poping up on wayland
    blacklistedKernelModules = ["amdgpu"];
  };
  hardware = {
    nvidia = {
      modesetting.enable = true;
      open = true;
      nvidiaSettings = true;
      # package = config.boot.kernelPackages.nvidiaPackages.beta;
      package = lib.mkForce config.boot.kernelPackages.nvidiaPackages.latest;
      # package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      #   version = "570.124.04";
      #   sha256_64bit = "sha256-G3hqS3Ei18QhbFiuQAdoik93jBlsFI2RkWOBXuENU8Q="; 
      #   settingsSha256 = "sha256-LNL0J/sYHD8vagkV1w8tb52gMtzj/F0QmJTV1cMaso8=";
      #   persistencedSha256 = lib.fakeSha256;
      #   sha256_aarch64 = lib.fakeSha256;
      #   openSha256 = lib.fakeSha256;
      # };

      # forceFullCompositionPipeline = true;
      powerManagement.enable = true;
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
    graphics.enable = true;
    graphics.enable32Bit = true;
  };
  # environment.systemPackages = with pkgs-unstable; [ linuxKernel.packages.linux_6_8.nvidia_x11 ];
  # services.xserver.videoDrivers = ["nvidia"];

  # (pkgs.linuxPackages_latest.nvidia_x11.overrideAttrs (old: {
  #   version = "555.42.02"; # replace with the latest version number
  #   src = pkgs.fetchurl {
  #     url = "https://us.download.nvidia.com/XFree86/Linux-x86_64/555.42.02/NVIDIA-Linux-x86_64-555.42.02.run";
  #     sha256 = "0aavhxa4jy7jixq1v5km9ihkddr2v91358wf9wk9wap5j3fhidwk";
  #   };
  # })) 

  ##### blacklist igpu
  # boot.kernelParams = [ "module_blacklist=amdgpu" ];
  # services.udev.extraRules = ''
  #   ACTION=="add", KERNEL=="0000:00:03.0", SUBSYSTEM=="pci", RUN+="/bin/sh -c 'echo 1 > /sys/bus/pci/devices/0000:6c:00.0/remove'"
  # '';
  #####
}