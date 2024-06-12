{ config, inputs, vars, lib, ... }:
# creates a user with only responsibility being to be a builder
with lib;
{
  options = {
    builder = {
      builder1 = {
        self = mkOption {
          type = types.bool;
          default = false;
        };
        remote = mkOption {
          type = types.bool;
          default = false;
        }; 
      };
    };
  };
  config = lib.mkMerge [
  (lib.mkIf (config.builder.builder1.self) {
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
  })
  (lib.mkIf (config.builder.builder1.remote) {
    nix.buildMachines = [ {
      hostName = "nixbuilder_dockeropen";
      system = "x86_64-linux";
      protocol = "ssh-ng";
      # if the builder supports building for multiple architectures, 
      # replace the previous line by, e.g.
      # systems = ["x86_64-linux" "aarch64-linux"];
      maxJobs = 2;
      speedFactor = 2;
      supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
      mandatoryFeatures = [ ];
    }] ;
  })
  ];
}
