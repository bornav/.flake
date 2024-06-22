{ inputs, vars, ... }:

let
  pkgs-stable = import inputs.nixpkgs-stable {
    config.allowUnfree = true;                              # Allow Proprietary Software
    system = "x86_64-linux";
  };

  pkgs-unstable = import inputs.nixpkgs-unstable {
    config.allowUnfree = true;
    system = "x86_64-linux";
  };

  pkgs-master = import inputs.nixpkgs-master {
    config.allowUnfree = true;
    system = "x86_64-linux";
  };
in
{
  vallium = inputs.nixpkgs-unstable.lib.nixosSystem {
    system = "x86_64-linux";  
    specialArgs = {
        # inherit (inputs.nixpkgs-unstable) lib;
        inherit  vars inputs;
        host = {
            hostName = "vallium";
        };
    };
    modules = [
      # nur.nixosModules.nur
      ./configuration.nix
      ./vallium
    ];
  };
  stealth = inputs.nixpkgs-unstable.lib.nixosSystem {
    system = "x86_64-linux";  
    specialArgs = {
        inherit  vars inputs;
        host = {
            hostName = "stealth";
        };
    };
    modules = [
      # nur.nixosModules.nur
      ./configuration.nix
      ./stealth
      
    ];
  };
  dockeropen = inputs.nixpkgs-unstable.lib.nixosSystem {
    system = "x86_64-linux";  
    specialArgs = {
        inherit pkgs-unstable vars inputs;
        host = {
            hostName = "dockeropen";
        };
    };
    modules = [
        # nur.nixosModules.nur
        ./configuration.nix
        ./dockeropen
        
    ];
  };
  k3s-local-01 = inputs.nixpkgs-stable.lib.nixosSystem {
    system = "x86_64-linux";  
    specialArgs = {
        inherit pkgs-stable vars inputs;
        host = {
            hostName = "k3s-local-01";
        };
    };
    modules = [
        # nur.nixosModules.nur
        # ./configuration.nix
        ./k3s-local-01
        # { disko.devices.disk.disk1.device = "/dev/sda"; }
    ];
  };
}
