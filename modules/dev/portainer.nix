{ lib, config, pkgs, pkgs-unstable, inputs, vars, ... }:
with lib;
{
#   imports = if mkIf (config.portainer.enable) then [ ../../custom/docker-compose/portainer/docker-compose.nix ] else [];
  options = {
    portainer = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
}