{ config, lib, inputs, host, pkgs, pkgs-stable, pkgs-unstable, pkgs-master, ... }:
{
  imports = [
      inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
  ];
  #nvidia
  boot = {
    initrd.kernelModules = [ "nvidia" ];
    kernelParams = lib.mkMerge [
      [
          "nvidia.NVreg_UsePageAttributeTable=1" # why this isn't default is beyond me.
          "nvidia.NVreg_EnableResizableBar=1" # enable reBAR
          "nvidia.NVreg_RegistryDwords=RmEnableAggressiveVblank=1" # low-latency stuff
          "nvidia_modeset.disable_vrr_memclk_switch=1" # stop really high memclk when vrr is in use.
      ]
      (lib.mkIf config.hardware.nvidia.powerManagement.enable [
          "nvidia.NVreg_TemporaryFilePath=/var/tmp" # store on disk, not /tmp which is on RAM
      ])
    ];
    blacklistedKernelModules = ["amdgpu"];
  };
  hardware = {
    nvidia = {
      # modesetting.enable = true;
      open = true;
      nvidiaSettings = true;
      package = lib.mkForce config.boot.kernelPackages.nvidiaPackages.beta;
      # package = lib.mkForce config.boot.kernelPackages.nvidiaPackages.latest;
      # package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      #   version = "580.76.05";
      #   sha256_64bit =   "sha256-IZvmNrYJMbAhsujB4O/4hzY8cx+KlAyqh7zAVNBdl/0=";  
      #   openSha256 =     "sha256-xEPJ9nskN1kISnSbfBigVaO6Mw03wyHebqQOQmUg/eQ=";
      #   settingsSha256 = "sha256-LNL0J/sYHD8vagkV1w8tb52gMtzj/F0QmJTV1cMaso8=";
      #   sha256_aarch64 = lib.fakeSha256;
      #   persistencedSha256 = lib.fakeSha256;
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
  environment = {
    sessionVariables = {
      # disable vsync
      __GL_SYNC_TO_VBLANK = "0";
      # enable gsync / vrr support
      __GL_VRR_ALLOWED = "1";

      # lowest frame buffering -> lower latency
      __GL_MaxFramesAllowed = "1";
      # fix hw acceleration and native wayland on losslesscut
      __EGL_VENDOR_LIBRARY_FILENAMES = "${config.hardware.nvidia.package}/share/glvnd/egl_vendor.d/10_nvidia.json";
      CUDA_CACHE_PATH = "$HOME/.cache/nv";
      # fix gtk4 freezes on 580
      GSK_RENDERER = "ngl";
    };
  };
  ##### blacklist igpu
  # boot.kernelParams = [ "module_blacklist=amdgpu" ];
  # services.udev.extraRules = ''
  #   ACTION=="add", KERNEL=="0000:00:03.0", SUBSYSTEM=="pci", RUN+="/bin/sh -c 'echo 1 > /sys/bus/pci/devices/0000:6c:00.0/remove'"
  # '';
  #####
}
