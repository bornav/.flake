{ config, inputs, vars, lib, ... }:
let
    pkgs = import inputs.nixpkgs-unstable {
        config.allowUnfree = true;
        system = "x86_64-linux";
    };
in
with lib;
{
  config = mkIf (config.emulation.switch) {
    environment.systemPackages = with pkgs; [
      ryujinx
    ];
  };
}
