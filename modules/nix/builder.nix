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
    users.users.nixbuilder = {
        isSystemUser = true;
        createHome = false;
        uid = 500;
        openssh.authorizedKeys.keys = [
         "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDeIvrOE9lMNjGuW6pm0RMGET8ze+Qr9/R4fgXplguadgOPi1rys3mRXkxMLMPgLbKrSRACt33arRprfnSbA6YIMl6WdaOSJAh0uPHeD82tt90F2DuQKCqCLmjbQenaFrjBlTlKnSpRTZd0m+5nfHOSE4XCyIllULhBKh6wrNdulJ3X7ZrpqS3gS/P5R7jxghScjUR/Y+GmhuLroow85LgzGQuoDfanm6YQgTB9Y+vYzUIZWs6edAEkGesTUJdnAxUIrEssBZUiWfw/ZqwK+APiQ0cCjcr8PR4wHMo0gK2Xgspn6FoIpogQBCJreQ2gColot9uYZaE6qla3JtAP3qlcjstkbh0qploijz0AMLLM8njs6hK5XSnjLsvc68q1OfS8NREWCs2z7m7ZR3UbeKcl1P3UkPsbCnqTFao618ISb2ButR5yFROqmKdk4fcQajdlKRtvgMc6zC0OI5ApyLCCIhPwGDrTjMl1rrAL7O1/aV8jg2X1Efqg1g1UV3qsmnSNUUO30W0EMI63KlynOF9uSpuBTc5we2OIK2hOF6ty5wpb3Y6a+vNnEl8A4QqvhTA0DZB4miH1PGweAc5P1mrNHcmj3oBGh3FxkxH8dpltkP5lckIHcRHZEKdLrQN0y54aoE9mfm08q3StmS0PDFI1LhUaH7wIxCApMLl+TYIFFw=="
        ];
        group = "nixbuilder";
        extraGroups = [ "networkmanager" "wheel" "docker" "NOPASSWD"];
        useDefaultShell = true;
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
    users.groups.nixbuilder = {
        gid = 500;
    };
    
    nix.settings.trusted-users = [ "nixbuilder" ];
    nix.distributedBuilds = true;
    # optional, useful when the builder has a faster internet connection than yours
    nix.extraOptions = ''
      builders-use-substitutes = true
    '';
  };
}
