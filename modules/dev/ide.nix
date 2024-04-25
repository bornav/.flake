{ lib, config, pkgs, pkgs-unstable, vars, ... }:
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
        istioctl
        # firefox           # Browser
      ];
  };
}