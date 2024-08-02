{ config, inputs, vars, lib, ... }:
let
    pkgs = import inputs.nixpkgs-unstable {
        config.allowUnfree = true;
        system = "x86_64-linux";
    };
in
with lib;
{
  config = mkIf (config.steam.enable) {
    programs = {
      steam = {
        enable = true;
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
        package = pkgs.steam.override {
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
      vkd3d
      vkd3d-proton
      protonup
      libpng
      icu
      mangohud
      gamemode
    ];
    environment.sessionVariables = {
        STEAM_EXTRA_COMPAT_TOOLS_PATHS = "$HOME/.steam/root/compatibilitytools.d";
    };
};}
