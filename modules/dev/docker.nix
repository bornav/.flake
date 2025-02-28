{ config, inputs, system, vars, lib, pkgs, ... }:
# let
#     pkgs = import inputs.nixpkgs-unstable {
#         config.allowUnfree = true;
#         inherit system;
#     };
# in
with lib;
{
  config = mkIf (config.docker.enable) {
  
  hardware.nvidia-container-toolkit.enable = true;
  virtualisation.docker.enable = true;
  virtualisation.docker.logDriver = lib.mkDefault "journald";
  virtualisation.containerd.enable = true;
  environment.systemPackages = [
      pkgs.docker-buildx
      # compose2nix.packages.x86_64-linux.default
    ];
  };
  
  # for multi arch builds running these 2 commands is required
  # docker buildx create --name=container --driver=docker-container --use --bootstrap
  # docker buildx build --builder=container --platform=linux/amd64,linux/arm64 .
  # docker buildx build --builder=container --platform=linux/amd64,linux/arm64 -t harbor.icylair.com/library/tcpforwarder --push .
  
  # weird command that makes docker buildx ls add arm to platforms :!:
  # docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
  # docker buildx create --use --name mybuilder --driver docker-container
  # docker buildx inspect mybuilder --bootstrap
  # https://docs.docker.com/build/building/multi-platform/#multiple-native-nodes
}

