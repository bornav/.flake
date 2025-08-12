{ config, inputs, system, vars, lib, pkgs,  ... }:
# let
#     pkgs = import inputs.nixpkgs-unstable {
#         config.allowUnfree = true;
#         inherit system;
#     };
# in
with lib;
{
  config = mkIf (config.emulation.switch) {
    environment.systemPackages = with pkgs; [
      # ryujinx
      ryubing
    ];
  };
}
