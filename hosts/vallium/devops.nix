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
  ] ++
    (with pkgs-unstable; [
      k9s
      # firefox           # Browser
    ]);
}