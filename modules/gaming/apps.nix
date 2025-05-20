{ config, inputs, system, vars, lib, pkgs, pkgs-stable, ... }:
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
with lib;
{
  config = mkIf (config.games.applications.enable) {
    environment.systemPackages = with pkgs; [
      # airshipper
      # heroic
      # heroic-unwrapped
      (heroic.override {
        extraPkgs = pkgs: [
          pkgs.gamescope
        ];
      })
      lutris
      gogdl
      # (bottles.override {
      #   removeWarningPopup = true;
      # })
    ] ++
    (with pkgs-stable; [
      # heroic
      # (heroic.override {
      #   extraPkgs = pkgs: [
      #     pkgs.gamescope
      #   ];
      # })
      shadps4
      umu-launcher
      # bottles
      # bottles-unwrapped

    ]);
};}
