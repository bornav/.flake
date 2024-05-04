{
  description = "A very basic flake";

  inputs = {                                                              # References Used by Flake
      # nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";                     # Stable Nix Packages (Default)
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
      nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";         # Unstable Nix Packages
      nixos-hardware.url = "github:NixOS/nixos-hardware/master"; #https://github.com/NixOS/nixos-hardware/tree/master
      home-manager = {                                                      # User Environment Manager
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      nix-flatpak.url = "github:gmodena/nix-flatpak";
      hyprland = {                                                          # Official Hyprland Flake
        url = "github:hyprwm/Hyprland";                                     # Requires "hyprland.nixosModules.default" to be added the host modules
        inputs.nixpkgs.follows = "nixpkgs";
      };
      nixos-cosmic = {
        url = "github:lilyinstarlight/nixos-cosmic";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      nur.url = "github:nix-community/NUR";
      disko.url = "github:nix-community/disko";
      disko.inputs.nixpkgs.follows = "nixpkgs";
    };
  outputs = { self, nur, nixpkgs, nixpkgs-unstable, home-manager, hyprland, nixos-cosmic, nixos-hardware, nix-flatpak, disko, ... } @ inputs:   # Function telling flake which inputs to use
	let
		vars = {                                                              # Variables Used In Flake
			user = "bocmo";
			location = "$HOME/.flake";
			terminal = "alacritty";
			editor = "vim";
      stateVersion = "24.05";
		};
    vars_dest = {
      
    };
	in {
		nixosConfigurations = (
			import ./hosts {
			inherit (nixpkgs) lib;
			inherit inputs self vars;   # Inherit inputs
			}
		);
		# homeConfigurations = (
		# 	import ./nix {
		# 	inherit (nixpkgs) lib;
		# 	inherit inputs nixpkgs nixpkgs-unstable home-manager vars;
		# 	}
		# );
	};
}
