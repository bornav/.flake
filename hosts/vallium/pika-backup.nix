{ pkgs, pkgs-stable, ... }:
{
  services.gvfs.enable = true;
  environment.systemPackages = [
    pkgs-stable.pika-backup
    pkgs.libglibutil
    pkgs.gvfs
    pkgs.gnome.gvfs
    ];
}
