{
  description = "A very basic flake";

  inputs = {                                                              # References Used by Flake
      # nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";                     # Stable Nix Packages (Default)
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
      nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";
      nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";         # Unstable Nix Packages
      nixpkgs-master.url = "github:nixos/nixpkgs/master"; 
      nixos-hardware.url = "github:NixOS/nixos-hardware/master"; #https://github.com/NixOS/nixos-hardware/tree/master
      home-manager = {url = "github:nix-community/home-manager";
                      inputs.nixpkgs.follows = "nixpkgs";};
      nix-flatpak.url = "github:gmodena/nix-flatpak";
      hyprland = {url = "github:hyprwm/Hyprland";                                     # Requires "hyprland.nixosModules.default" to be added the host modules
                  inputs.nixpkgs.follows = "nixpkgs";};
      nixos-cosmic = {url = "github:lilyinstarlight/nixos-cosmic";
                      inputs.nixpkgs.follows = "nixpkgs";};
      nur.url = "github:nix-community/NUR";
      disko = {url = "github:nix-community/disko";
               inputs.nixpkgs.follows = "nixpkgs";};
      compose2nix = {url = "github:aksiksi/compose2nix";
                     inputs.nixpkgs.follows = "nixpkgs";};
    };
  outputs = { self, nur, nixpkgs, nixpkgs-unstable, nixpkgs-stable, nixpkgs-master, home-manager, hyprland, nixos-cosmic, nixos-hardware, compose2nix, nix-flatpak, disko, ... } @ inputs:   # Function telling flake which inputs to use
	let
		vars = {                                                              # Variables Used In Flake
			user = "bocmo";
			location = "$HOME/.flake";
			terminal = "alacritty";
			editor = "vim";
      stateVersion = "24.05";
		};
    inherit (self) outputs;
	in {
		nixosConfigurations = (
			import ./hosts {
			inherit (nixpkgs) lib;
			inherit inputs outputs self vars;   # Inherit inputs
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
