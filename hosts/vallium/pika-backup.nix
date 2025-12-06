{ pkgs, ... }:
{
  services.gvfs.enable = true;
  environment.systemPackages = [
    pkgs.libglibutil
    pkgs.gvfs
    pkgs.gnome.gvfs
    ];
}
