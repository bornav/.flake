{ lib, config, pkgs, pkgs-unstable, vars, ... }:
with lib;
{
  options = {
    devops = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
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
      # terraform
      inetutils
      dig
    ] ++
      (with pkgs-unstable; [
        k9s
        istioctl
        # firefox           # Browser
      ]);
  };
}
