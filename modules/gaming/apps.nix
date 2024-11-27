{ config, inputs, system, vars, lib, ... }:
let
    pkgs = import inputs.nixpkgs-unstable {
        config.allowUnfree = true;
        inherit system;
    };
in
with lib;
{
  config = mkIf (config.games.applications.enable) {
    environment.systemPackages = with pkgs; [
      airshipper
      # heroic
      # heroic-unwrapped
      gogdl
    ];
};}
