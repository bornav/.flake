{ config, inputs, vars, lib, ... }:
let
    pkgs = import inputs.nixpkgs-unstable {
        config.allowUnfree = true;
        system = "x86_64-linux";
    };
in
with lib;
{
  options = {
    ide = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config = mkIf (config.ide.enable) {
    environment.systemPackages = with pkgs; [
        vscode
        vscode-extensions.continue.continue
        istioctl
        # firefox           # Browser
      ];
  };
}