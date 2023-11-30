{ config, pkgs, pkgs-unstable, vars, ... }:
{
  environment.systemPackages = with pkgs; [
    flux
    fluxcd
    kubectl
    sops
    age
    k9s
  ];
}