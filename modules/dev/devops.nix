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
    environment.systemPackages = with pkgs; [
      flux
      fluxcd
      kubectl
      sops
      age
      ansible
      kubernetes-helm
      kustomize
      kustomize-sops
      lens
      bfg-repo-cleaner
      inetutils
      dig
      k9s
      yq
      yaml-language-server  # TODO look into
      nil # TODO move into ide
      inputs.compose2nix.packages.x86_64-linux.default
      thttpd # htpasswd
    ];
    # environment.systemPackages = [
    #   compose2nix.packages.x86_64-linux.default
    # ];
    virtualisation.docker.enable = true;
    # virtualisation.containerd.enable = true;
  };
}
