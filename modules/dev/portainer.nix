{ config, inputs, system, vars, lib, ... }:
let
    pkgs = import inputs.nixpkgs-unstable {
        config.allowUnfree = true;
        inherit system;
    };
in
with lib;
{
#   imports = if mkIf (config.portainer.enable) then [ ../../custom/docker-compose/portainer/docker-compose.nix ] else [];
  imports = [ ../../custom/docker-compose/portainer/docker-compose.nix ];
  config = mkIf (config.portainer.enable) {};
}