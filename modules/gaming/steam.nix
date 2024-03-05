{ lib, config, pkgs, pkgs-unstable, vars, ... }:
with lib;
{
  options = {
    steam = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config = mkIf (config.steam.enable) {
    programs.steam = {
      enable = true;
      package = pkgs-unstable.steam;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    };
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "steam"
      "steam-original"
      "steam-run"
    ];
    environment.systemPackages = with pkgs; [
      openssl
    ];
};}