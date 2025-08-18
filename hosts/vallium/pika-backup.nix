{ config, lib, inputs, host, pkgs, pkgs-stable, pkgs-unstable, pkgs-master, ... }:
{
  services.gvfs.enable = true;
  environment.systemPackages = [
    pkgs-unstable.libglibutil
    pkgs-unstable.gvfs
    pkgs-unstable.gnome.gvfs
    ] ++ (with pkgs; [

    ]) ++ (with pkgs-stable; [
      
    ]);
}
