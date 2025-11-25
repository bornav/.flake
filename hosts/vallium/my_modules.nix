{ lib, ... }:
{
  # gnome.enable = lib.mkDefault true;
  plasma.enable = lib.mkDefault true;
  # hyprland.enable = lib.mkForce false;
  cosmic-desktop.enable = lib.mkDefault false;
  virtualization.enable = true;
  virtualization.qemu = true;
  # virtualization.waydroid = true;
  devops.enable = true;
  steam.enable = true;
  emulation.switch = true;
  games.applications.enable = true;
  rar.enable = true;
  thorium.enable = true;
  wg-home.enable = false;
  ai.enable = true;
  docker.enable = true;
  podman.enable = true;
  builder.builder1.remote = false;
  ide.vscode = true;
  ide.zed = true;
  flatpak.enable = true;

  device.woothing = true;
  device.finalmouse = true;
  device.orbital-pathfinder = true;

  storagefs.share.vega_nfs = true;
}
