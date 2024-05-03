{ config, pkgs, pkgs-unstable, vars, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./network-shares.nix
  ];
}
