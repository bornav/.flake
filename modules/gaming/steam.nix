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
    programs = {
      steam = {
        enable = true;
        # package = pkgs-unstable.steam;
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
        package = pkgs-unstable.steam.override {
          extraPkgs = pkgs: 
            with pkgs; [
              mangohud
              openssl
              libpng
              icu
              gamemode
            ];
        };
        gamescopeSession.enable = true;
      };
      gamemode.enable = true;
    };
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "steam"
      "steam-original"
      "steam-run"
    ];
    environment.systemPackages = with pkgs; [
      openssl
      libpng
      icu 
      mangohud
      gamemode
    ];
    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
};}