{ config, inputs, system, vars, lib, ... }:
let
    pkgs = import inputs.nixpkgs-unstable {
        config.allowUnfree = true;
        inherit system;
    };
in
with lib;
{
  config = mkIf (config.devops.enable) {
  
  hardware.nvidia-container-toolkit.enable = true;
  virtualisation.docker.enable = true;
  virtualisation.docker.logDriver = lib.mkDefault "journald";
  virtualisation.docker.enableNvidia = true;
  virtualisation.containerd.enable = true;
  # environment.systemPackages = [
    #   compose2nix.packages.x86_64-linux.default
    # ];
  };
  # for multi arch builds running these 2 commands is required
  # docker buildx create --name=container --driver=docker-container --use --bootstrap
  # docker buildx build --builder=container --platform=linux/amd64,linux/arm64 .
  # docker buildx build --builder=container --platform=linux/amd64,linux/arm64 -t harbor.icylair.com/library/tcpforwarder --push .
  
}

