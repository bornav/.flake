{ config, pkgs, pkgs-unstable, vars, ... }:
{
  environment.systemPackages = with pkgs; [
    flux
    fluxcd
    k9s
  ];
}