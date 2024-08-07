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
    # system = "x86_64-linux";  
    specialArgs = {
        # inherit (inputs.nixpkgs-unstable) lib;
        inherit  vars inputs;
        host = {
            hostName = "vallium"; # TODO, put system in here and pass host around
        };
        system = "x86_64-linux";  
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
      system = "x86_64-linux"; 
    };
    modules = [
      # nur.nixosModules.nur
      ./configuration.nix
      ./stealth
      
    ];
  };
  dockeropen = inputs.nixpkgs-unstable.lib.nixosSystem {
    # system = "x86_64-linux";  
    specialArgs = {
      inherit pkgs-unstable vars inputs;
      host = {
          hostName = "dockeropen";
      };
      system = "x86_64-linux"; 
    };
    modules = [
        # nur.nixosModules.nur
        ./configuration.nix
        ./dockeropen
        
    ];
  };
  k3s-local-01 = inputs.nixpkgs-unstable.lib.nixosSystem {
    system = "x86_64-linux";  
    specialArgs = {
      inherit pkgs-unstable vars inputs;
      host = {
          hostName = "k3s-local-01";
      };
      system = "x86_64-linux";
    };
    modules = [
        ./k3s-local-01
    ];
  };
  k3s-oraclearm2 = inputs.nixpkgs-unstable.lib.nixosSystem {
    system = "aarch64-linux";  
    specialArgs = {
      inherit pkgs-unstable vars inputs;
      host = {
          hostName = "k3s-oraclearm2";
      };
      system = "aarch64-linux";  
    };
    modules = [
        ./k3s-oraclearm2
    ];
  };
  k3s-oraclearm1 = inputs.nixpkgs-unstable.lib.nixosSystem {
    system = "aarch64-linux";  
    specialArgs = {
      inherit pkgs-unstable vars inputs;
      host = {
          hostName = "k3s-oraclearm1";
      };
      system = "aarch64-linux";  
    };
    modules = [
        ./k3s-oraclearm1
    ];
  };
  ## unused v
  k3s-local = inputs.nixpkgs-unstable.lib.nixosSystem {
    system = "x86_64-linux";  
    specialArgs = {
        inherit pkgs-unstable vars inputs;
        host = {
            hostName = "k3s-local";
            system = "x86_64-linux";  
        };
        system = "x86_64-linux"; 
    };
    modules = [
        ./k3s-local
    ];
  };
}
