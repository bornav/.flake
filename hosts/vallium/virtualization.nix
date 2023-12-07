{ config, pkgs, pkgs-unstable, vars, ... }:
{
    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;
}