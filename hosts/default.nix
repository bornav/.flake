{ lib, inputs, vars, ... }:

let
  system = "x86_64-linux";                                  # System Architecture

  # pkgs = import inputs.nixpkgs {
  #   inherit system;
  #   config.allowUnfree = true;                              # Allow Proprietary Software
  # };

  pkgs-unstable = import inputs.nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };

  # pkgs-master = import inputs.nixpkgs-master {
  #   inherit system;
  #   config.allowUnfree = true;
  # };
in
{
    vallium = inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
            inherit system pkgs-unstable vars inputs;
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
          inputs.nixos-cosmic.nixosModules.default
          inputs.nixos-hardware.nixosModules.common-cpu-amd
          inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
          inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
          inputs.nixos-hardware.nixosModules.common-pc-ssd
          inputs.nix-flatpak.nixosModules.nix-flatpak
          ];
    };
    stealth = inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
            inherit system pkgs-unstable vars inputs;
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
          inputs.nixos-cosmic.nixosModules.default
          inputs.nixos-hardware.nixosModules.common-pc-ssd
          inputs.nixos-hardware.nixosModules.common-cpu-intel
          inputs.nixos-hardware.nixosModules.common-cpu-intel-kaby-lake
          ];
    };
    dockeropen = inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
            inherit system pkgs-unstable vars inputs;
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
