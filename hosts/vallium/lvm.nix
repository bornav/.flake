{ config, lib, inputs, host, pkgs, pkgs-stable, pkgs-unstable, pkgs-master, ... }:
{
  boot.initrd.kernelModules = [
    "dm-snapshot" # when you are using snapshots
    "dm-raid" # e.g. when you are configuring raid1 via: `lvconvert -m1 /dev/pool/home`
    "dm-cache-default" # when using volumes set up with lvmcache
  ];

  services.lvm = {
    enable = true;
    boot.thin.enable = true; # Potentially needed for tool paths
  };
  environment.systemPackages = with pkgs-unstable; [
    thin-provisioning-tools
  ];
}
