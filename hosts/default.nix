{ lib, inputs, nixpkgs, nixpkgs-unstable, home-manager, hyprland, nixos-cosmic, vars, ... }:

let
  system = "x86_64-linux";                                  # System Architecture

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;                              # Allow Proprietary Software
  };

  pkgs-unstable = import nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };
in
{
    vallium = nixpkgs.lib.nixosSystem { 
        inherit system; 
        specialArgs = {
            inherit system pkgs-unstable hyprland vars inputs;
            host = {
                hostName = "vallium";
            };
        };
        modules = [ 
          # nur.nixosModules.nur
          ./configuration.nix
          ./vallium
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
          # {
          # nix.settings = {
          #     substituters = [ "https://cosmic.cachix.org/" ];
          #     trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
          #   };
          # }
          nixos-cosmic.nixosModules.default
          ];        
    };
    stealth = nixpkgs.lib.nixosSystem { 
        inherit system; 
        specialArgs = {
            inherit system pkgs-unstable hyprland vars inputs;
            host = {
                hostName = "stealth";
            };
        };
        modules = [ 
          # nur.nixosModules.nur
          ./configuration.nix
          ./stealth
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
          nixos-cosmic.nixosModules.default
          ];
    };
  #   ##### nixos settings, check if they apply
  #   system = {                                # NixOS Settings
  #   autoUpgrade = {                        # Allow Auto Update (not useful in flakes)
  #    enable = true;
  #    flake = inputs.self.outPath;
  #    flags = [
  #      "--update-input"
  #      "nixpkgs"
  #      "-L"
  #    ];
  #   };
  #   stateVersion = "${vars.stateVersion}";
  # };
  # home-manager.users.${vars.user} = {       # Home-Manager Settings
  #   home.stateVersion = "${vars.stateVersion}";
  #   programs.home-manager.enable = true;
  # };
  # nix = {
  #   settings.auto-optimise-store = true;
  #   gc = {                                  # Garbage Collection
  #     automatic = true;
  #     dates = "weekly";
  #     options = "--delete-older-than 14d";
  #   };
  #   package = pkgs.nixFlakes;
  #   extraOptions = "experimental-features = nix-command flakes";
  # };
}