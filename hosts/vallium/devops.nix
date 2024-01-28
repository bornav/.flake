{ config, pkgs, pkgs-unstable, vars, ... }:
{
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
    terraform
  ] ++
    (with pkgs-unstable; [
      k9s
      istioctl
      # firefox           # Browser
    ]);
}