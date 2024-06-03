{ inputs, vars, ... }:

let
  # pkgs = import inputs.nixpkgs {
  #   config.allowUnfree = true;                              # Allow Proprietary Software
  # };

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
            inherit  pkgs-unstable vars inputs;
            host = {
                hostName = "vallium";
            };
        };
        modules = [
          # nur.nixosModules.nur
          ./configuration.nix
          ./vallium
          {
            nix.settings = {
              substituters = [ "https://cosmic.cachix.org/" ];
              trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
            };
          }
          ];
    };
    stealth = inputs.nixpkgs-unstable.lib.nixosSystem {
        system = "x86_64-linux";  
        specialArgs = {
            inherit  pkgs-unstable vars inputs;
            host = {
                hostName = "stealth";
            };
        };
        modules = [
          # nur.nixosModules.nur
          ./configuration.nix
          ./stealth
          
          {
            nix.settings = {
              substituters = [ "https://cosmic.cachix.org/" ];
              trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
            };
          }
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
}
