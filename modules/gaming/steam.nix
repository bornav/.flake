{
  config,
  inputs,
  system,
  vars,
  host,
  lib,
  pkgs,
  ...
}:
# let
#     pkgs = import inputs.nixpkgs-unstable {
#         config.allowUnfree = true;
#         inherit system;
#     };
# in
with lib; {
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
              # gamemode
              xorg.libXcursor
              xorg.libXi
              xorg.libXinerama
              xorg.libXScrnSaver
              libpng
              libpulseaudio
              libvorbis
              stdenv.cc.cc.lib
              libkrb5
              keyutils
            ];
          extraProfile = let
            gmLib = "${lib.getLib (pkgs.gamemode)}/lib";
          in ''
            export LD_LIBRARY_PATH="${gmLib}:$LD_LIBRARY_PATH"
          '';
        };
        gamescopeSession.enable = true;
      };
      gamemode.enable = true;
      gamescope = {
        enable = true;
        capSysNice = true;
      };
    };
    nixpkgs.config.packageOverrides = pkgs: {
      steam = pkgs.steam.override {
        extraPkgs = pkgs:
          with pkgs; [
            pango
            libthai
            harfbuzz
          ];
      };
    };
    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "steam"
        "steam-original"
        "steam-run"
      ];
    environment.systemPackages = [
      pkgs.openssl
      pkgs.vkd3d
      pkgs.vkd3d-proton
      pkgs.protonup-ng
      pkgs.libpng
      pkgs.icu
      pkgs.mangohud
      pkgs.gamemode

      # pkgs-unstable.wine
      # pkgs-unstable.wine-wayland
      # pkgs-unstable.wineWowPackages.unstableFull
      # pkgs-unstable.winetricks
      pkgs.protontricks
      pkgs.vulkan-tools
      # Extra dependencies
      # https://github.com/lutris/docs/
      pkgs.gnutls
      pkgs.openldap
      pkgs.libgpg-error
      pkgs.freetype
      pkgs.sqlite
      pkgs.libxml2
      pkgs.xml2
      pkgs.SDL2
      pkgs.protonplus
    ];
    environment.sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "$HOME/.steam/root/compatibilitytools.d";
    };
    hardware.graphics.enable32Bit = true;
    home-manager = {
      backupFileExtension = "backup";
      extraSpecialArgs = {inherit inputs;};
      users.${host.vars.user} = lib.mkMerge [
        (import ./home-mutable-mangohud.nix)
      ];
    };
  };
}
