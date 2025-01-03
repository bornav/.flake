{ config, lib, host, inputs, ... }:
let
  pkgs = import inputs.nixpkgs-unstable {
    system = host.system;
    config.allowUnfree = true;
  };
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = host.system;
    config.allowUnfree = true;
  };
in
{
  nixpkgs.config.allowUnfree = true;
  hardware = {
    nvidia = {
      modesetting.enable = true;
      open = false;
      nvidiaSettings = true;
      package = lib.mkForce config.boot.kernelPackages.nvidiaPackages.latest;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
    };
    graphics.enable32Bit = true;
    graphics.enable = true;
  };


  services.xserver.videoDrivers = ["nvidia"]; # this is important

  ## in virtualization, find out how to import at the top
  users.users.${host.vars.user}.extraGroups = [ "libvirtd" ];
  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true; # virt-manager requires dconf to remember settings
  environment.systemPackages = with pkgs; [ 
      virt-manager
      virt-viewer
      qemu
      spice
      libgcc
  ];
  programs.appimage.binfmt = true;

  # hardware.nvidia.datacenter.enable = true;

  boot.kernelParams = [ "nvidia_drm.fbdev=1" ];
  # virtualisation.cri-o.enable = true;
  hardware.nvidia-container-toolkit.enable = true;
  virtualisation.docker.enable = true;
  # virtualisation.docker.logDriver = lib.mkDefault "journald";
  virtualisation.docker.enableNvidia = true;
  virtualisation.containerd.enable = true;
  # virtualisation.containerd.configFile = "/etc/containerd/config.toml";
  # virtualisation.cri-o.enable = true;
  # virtualisation.containerd = {
  #    settings = {
  #     version = 2;
  #     plugins."io.containerd.grpc.v1.cri" = {
  #       default_runtime_name = "nvidia";
  #       containerd = {
  #         default_runtime_name = "nvidia";
  #         runtimes.nvidia = {
  #           runtime_type = "io.containerd.runc.v2";
  #           privileged_without_host_devices = false;
  #           options = {
  #             BinaryName = "/usr/bin/nvidia-container-runtime";
  #           };
  #         };
  #       };
  #     };
  #   };
  # };
}
