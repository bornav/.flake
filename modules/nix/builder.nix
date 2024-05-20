{ lib, config, pkgs, pkgs-unstable, vars, ... }:
# creates a user with only responsibility being to be a builder
with lib;
{
  options = {
    builder = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config = mkIf (config.builder.enable) {
    users = {
      users.nixbuilder = {
        isSystemUser = true;
        createHome = false;
        uid = 500;
        openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEGiVyNsVCk2KAGfCGosJUFig6PyCUwCaEp08p/0IDI7"];
        group = "nixbuilder";
        extraGroups = [ "networkmanager" "wheel" "docker" "NOPASSWD"];
        useDefaultShell = true;
      };
      groups.nixbuilder = {
        gid = 500;
      };
    };
    
    security.sudo.extraRules = [
      {  users = [ "nixbuilder" ];
        commands = [
          { command = "ALL" ;
            options= [ "NOPASSWD" ]; # "SETENV" # Adding the following could be a good idea
          }
        ];
      }
    ];
    
    nix.settings.trusted-users = [ "nixbuilder" ];
    nix.distributedBuilds = true;
    # optional, useful when the builder has a faster internet connection than yours
    nix.extraOptions = ''
      builders-use-substitutes = true
    '';
  };
}
