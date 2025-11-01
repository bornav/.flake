{ config, lib, inputs, ... }:
{
  imports = [
      inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
  ];
  #nvidia
  boot = {
    initrd.kernelModules = [
      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
    ];
    kernelParams = lib.mkMerge [
      [
          "nvidia.NVreg_UsePageAttributeTable=1" # why this isn't default is beyond me.
          "nvidia.NVreg_EnableResizableBar=1" # enable reBAR
          "nvidia.NVreg_RegistryDwords=RmEnableAggressiveVblank=1" # low-latency stuff
      ]
      (lib.mkIf config.hardware.nvidia.powerManagement.enable [
          "nvidia.NVreg_TemporaryFilePath=/var/tmp" # store on disk, not /tmp which is on RAM
      ])
    ];
    blacklistedKernelModules = [
      "amdgpu"
      "nouveau"
    ];
  };
  nixpkgs.overlays = [
    # (final: _: {
    #   egl-wayland = final.customPkgs.egl-wayland2;
    # })
  ];
  hardware = {
    nvidia = {
      # modesetting.enable = true;
      open = true;
      gsp.enable = config.hardware.nvidia.open; # if using closed drivers, lets assume you don't want gsp

      nvidiaSettings = false;
      package = lib.mkForce config.boot.kernelPackages.nvidiaPackages.beta;
      # package = lib.mkForce config.boot.kernelPackages.nvidiaPackages.latest;
      # package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      #   version = "580.95.05";
      #   sha256_64bit = "sha256-hJ7w746EK5gGss3p8RwTA9VPGpp2lGfk5dlhsv4Rgqc=";
      #   openSha256 = "sha256-RFwDGQOi9jVngVONCOB5m/IYKZIeGEle7h0+0yGnBEI=";
      #   usePersistenced = false;
      #   useSettings = false;
      # };
      # forceFullCompositionPipeline = true;
      powerManagement.enable = true;
      # powerManagement.finegrained = false;
      #
      videoAcceleration = true;
    };
    graphics = {
      enable = true;
      enable32Bit = true;
    };
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
      __EGL_VENDOR_LIBRARY_FILENAMES = "/run/opengl-driver/share/glvnd/egl_vendor.d/10_nvidia.json";
      CUDA_CACHE_PATH = "$HOME/.cache/nv";
      # # fix gtk4 freezes on 580
      # GSK_RENDERER = "ngl";
    };
  };
  ##### blacklist igpu
  # boot.kernelParams = [ "module_blacklist=amdgpu" ];
  # services.udev.extraRules = ''
  #   ACTION=="add", KERNEL=="0000:00:03.0", SUBSYSTEM=="pci", RUN+="/bin/sh -c 'echo 1 > /sys/bus/pci/devices/0000:6c:00.0/remove'"
  # '';
  #####
  #

  # Set power limit
  systemd.services.nvidia-gpu-powerlimit = {
    description = "Set NVIDIA GPU power limit";
    wantedBy = [ "multi-user.target" ];
    after = [
      # "nvidia-persistenced.service"
      "systemd-udev-settle.service"
    ];
    # requires = [ "nvidia-persistenced.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = [
        "${config.hardware.nvidia.package.bin}/bin/nvidia-smi -pl 350" # number indicates watts, there is diff min,max per gpu
      ];
    };
  };
}
