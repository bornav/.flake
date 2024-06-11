{ config, inputs, vars, lib, ... }:
with lib;
{
  options = {
    storagefs.share = {
      vega_nfs = mkOption {
        type = types.bool;
        default = false;
      };
      vega_smb = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config = lib.mkMerge [

    (lib.mkIf (config.storagefs.share.vega_nfs) {
      fileSystems."/home/${vars.user}/.share/vega_nfs" = {#truenas nfs storage
        device = "10.2.11.200:/mnt/vega/vega";
        fsType = "nfs";
        options = [ "x-systemd.automount" "noauto" "x-systemd.device-timeout=5s" "x-systemd.mount-timeout=5s"];
      };
    })
    (lib.mkIf (config.storagefs.share.vega_smb) {
    fileSystems."/home/${vars.user}/.share/vega" = { #truenas smb storage
      device = "//10.2.11.200/vega";
      fsType = "cifs";
      options = let
        automount_opts = "x-systemd.automount,user,soft,noauto,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
        # automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
      in ["${automount_opts},mfsymlinks,uid=1000,gid=1000,credentials=/home/${vars.user}/.share/creds/vega"];
      };
    })
  ]; 
}
