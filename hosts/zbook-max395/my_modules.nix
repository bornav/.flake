{ lib, ... }:
{
  #### modules
  gnome.enable = lib.mkDefault false;
  plasma.enable = lib.mkDefault true;
  cosmic-desktop.enable = lib.mkDefault false;
  virtualization.enable = true;
  devops.enable = true;
  steam.enable = true;
  thorium.enable = true;
  rar.enable = true;
  # wg-home.enable = true;
  wg-home.local_ip = "10.10.1.3/32";
  wg-home.privateKeyFileLocation = "/home/user/.ssh/wg/zbook/priv.key";
  # flatpak.enable = true;
  # storagefs.share.vega_nfs = true;
  # storagefs.share.vega_smb = true;
  ide.vscode = true;
  ide.zed = true;
  docker.enable = true;
  ####
}
