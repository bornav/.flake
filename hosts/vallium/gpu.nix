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
  nixpkgs.config.allowUnfree = !config.hardware.nvidia.gsp.enable;
  nixpkgs.config.nvidia.acceptLicense = !config.hardware.nvidia.gsp.enable;
  # nixpkgs.overlays = [
  #   (final: _: {
  #     egl-wayland = final.customPkgs.egl-wayland2;
  #   })
  # ];
  hardware = {
    nvidia = {
      # modesetting.enable = true;
      open = false;
      gsp.enable = config.hardware.nvidia.open; # if using closed drivers, lets assume you don't want gsp
      nvidiaSettings = false;
      # package = lib.mkForce config.boot.kernelPackages.nvidiaPackages.beta;
      # package = lib.mkForce config.boot.kernelPackages.nvidiaPackages.latest;
      package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
        version = "590.44.01";
        sha256_64bit = "sha256-VbkVaKwElaazojfxkHnz/nN/5olk13ezkw/EQjhKPms=";
        openSha256 = "sha256-FGmMt3ShQrw4q6wsk8DSvm96ie5yELoDFYinSlGZcwQ=";
        usePersistenced = false;
        useSettings = false;
      };
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
      VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json"; # if this missing getting warning terminator_CreateInstance in `vulkaninfo --summary`
      # disable vsync
      __GL_SYNC_TO_VBLANK = "0";
      # enable gsync / vrr support
      __GL_VRR_ALLOWED = "1";

      # lowest frame buffering -> lower latency
      __GL_MaxFramesAllowed = "1";
      # fix hw acceleration and native wayland on losslesscut
      __EGL_VENDOR_LIBRARY_FILENAMES = "/run/opengl-driver/share/glvnd/egl_vendor.d/10_nvidia.json";
      # fix hw acceleration in bwrap (osu!lazer, wrapped appimages)
      __EGL_EXTERNAL_PLATFORM_CONFIG_DIRS = "/run/opengl-driver/share/egl/egl_external_platform.d";
      CUDA_CACHE_PATH = "$XDG_CACHE_HOME/nv";
      CUDA_DISABLE_PERF_BOOST = 1; # TODO LOOK IF REMOVE NECESSARY
    };
  };
  ##### blacklist igpu
  # boot.kernelParams = [ "module_blacklist=amdgpu" ];
  # services.udev.extraRules = ''
  #   ACTION=="add", KERNEL=="0000:00:03.0", SUBSYSTEM=="pci", RUN+="/bin/sh -c 'echo 1 > /sys/bus/pci/devices/0000:6c:00.0/remove'"
  # '';
  #####
  #

  # # Set power limit
  # systemd.services.nvidia-gpu-powerlimit = {
  #   description = "Set NVIDIA GPU power limit";
  #   wantedBy = [ "multi-user.target" ];
  #   after = [
  #     # "nvidia-persistenced.service"
  #     "systemd-udev-settle.service"
  #   ];
  #   # requires = [ "nvidia-persistenced.service" ];
  #   serviceConfig = {
  #     Type = "oneshot";
  #     RemainAfterExit = true;
  #     ExecStart = [
  #       "${config.hardware.nvidia.package.bin}/bin/nvidia-smi -pl 350" # number indicates watts, there is diff min,max per gpu
  #     ];
  #   };
  # };
}
