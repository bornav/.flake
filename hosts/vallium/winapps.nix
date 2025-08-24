{ config, lib, inputs, host, pkgs, pkgs-stable, pkgs-unstable, pkgs-master, ... }:
{
  environment.systemPackages = [
    inputs.winapps.packages."${host.system}".winapps
    inputs.winapps.packages."${host.system}".winapps-launcher # optional
  ];
}
