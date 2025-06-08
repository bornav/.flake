{ config, lib, host, inputs, pkgs, pkgs-unstable, ... }:
# let
#   pkgs = import inputs.nixpkgs-unstable {
#     system = host.system;
#     config.allowUnfree = true;
#   };
#   pkgs-unstable = import inputs.nixpkgs-unstable {
#     system = host.system;
#     config.allowUnfree = true;
#   };
# in
{

  services.forgejo = {
    enable = true;
    stateDir = "/share/git/stateDir";
    customDir = "/share/git/customDir";
    settings = {
      server.DOMAIN = "git.icylair.com";
      # "Trace", "Debug", "Info", "Warn", "Error", "Critical"
      log.LEVEL = "Info";
    };
  };






  # Storage
  fileSystems."/share/git" = {#truenas nfs storage
    device = "10.2.11.200:/mnt/vega/vega/data/docker_data/git/";
    fsType = "nfs";
    options = [ "hard" "timeo=50" "x-systemd.automount" "noauto" "x-systemd.device-timeout=5s" "x-systemd.mount-timeout=5s"];
  };
}