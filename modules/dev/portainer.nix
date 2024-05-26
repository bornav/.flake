{ config, inputs, vars, lib, ... }:
let
    pkgs = import inputs.nixpkgs-unstable {
        config.allowUnfree = true;
        system = "x86_64-linux";
    };
in
with lib;
{
#   imports = if mkIf (config.portainer.enable) then [ ../../custom/docker-compose/portainer/docker-compose.nix ] else [];
  imports = [ ../../custom/docker-compose/portainer/docker-compose.nix ];
  options = {
    portainer = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config = mkIf (config.portainer.enable) {};
}