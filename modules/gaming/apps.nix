{
  config,
  inputs,
  system,
  vars,
  lib,
  pkgs,
  pkgs-stable,
  ...
}:
# let
#     pkgs = import inputs.nixpkgs-unstable {
#         config.allowUnfree = true;
#         inherit system;
#     };
#     pkgs-stable = import inputs.nixpkgs-stable {
#         config.allowUnfree = true;
#         inherit system;
#     };
# in
with lib; {
  config = mkIf (config.games.applications.enable) {
    environment.systemPackages = [
      # airshipper
      # heroic-unwrapped
      pkgs-stable.heroic
      # (heroic.override {
      #   extraPkgs = pkgs: [
      #     pkgs.gamescope
      #   ];
      # })
      (pkgs-stable.bottles.override {removeWarningPopup = true;}) #TODO investigate how this is done on the source and document, 14.06.2025 nixos-unstable
      # pkgs.lutris
      pkgs-stable.lutris
      pkgs.gogdl
      # (bottles.override {
      #   removeWarningPopup = true;
      # })
      pkgs.shadps4
      pkgs.umu-launcher
    ];
    boot.kernelModules = [
      "ntsync"
    ];
    services.udev.extraRules = ''
      KERNEL=="ntsync", MODE="0644"
    '';
  };
}
