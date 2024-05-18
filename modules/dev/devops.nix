{ lib, config, pkgs, pkgs-unstable, inputs, vars, ... }:
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
      inetutils
      dig
      yaml-language-server
      inputs.compose2nix.packages.x86_64-linux.default
    ] ++
      (with pkgs-unstable; [
        k9s
      ]);
    # environment.systemPackages = [
    #   compose2nix.packages.x86_64-linux.default
    # ];
    virtualisation.docker.enable = true;
  };
}
