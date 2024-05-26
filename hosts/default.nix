{ lib, inputs, vars, ... }:

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
            inherit  pkgs-unstable vars inputs;
            host = {
                hostName = "vallium";
            };
        };
        modules = [
          # nur.nixosModules.nur
          ./configuration.nix
          ./vallium
          inputs.home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
          {
            nix.settings = {
              substituters = [ "https://cosmic.cachix.org/" ];
              trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
            };
          }
          inputs.nixos-cosmic.nixosModules.default
          inputs.nixos-hardware.nixosModules.common-cpu-amd
          inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
          inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
          inputs.nixos-hardware.nixosModules.common-pc-ssd
          inputs.nix-flatpak.nixosModules.nix-flatpak
          ];
    };
    stealth = inputs.nixpkgs.lib.nixosSystem {
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
          inputs.home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
          {
            nix.settings = {
              substituters = [ "https://cosmic.cachix.org/" ];
              trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
            };
          }
          inputs.nixos-cosmic.nixosModules.default
          inputs.nixos-hardware.nixosModules.common-pc-ssd
          inputs.nixos-hardware.nixosModules.common-cpu-intel
          inputs.nixos-hardware.nixosModules.common-cpu-intel-kaby-lake
          ];
    };
    dockeropen = inputs.nixpkgs.lib.nixosSystem {
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
            inputs.home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            }
            inputs.nixos-cosmic.nixosModules.default
            inputs.nixos-hardware.nixosModules.common-cpu-amd
            inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
            inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
            inputs.nixos-hardware.nixosModules.common-pc-ssd
            inputs.nix-flatpak.nixosModules.nix-flatpak
            inputs.disko.nixosModules.disko
            ];
    };
}
