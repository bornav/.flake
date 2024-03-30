{
  description = "A very basic flake";

  inputs =                                                                  # References Used by Flake
    {
      # nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";                     # Stable Nix Packages (Default)
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; 
      nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";         # Unstable Nix Packages
      home-manager = {                                                      # User Environment Manager
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs-unstable";
      };
      hyprland = {                                                          # Official Hyprland Flake
        url = "github:hyprwm/Hyprland";                                     # Requires "hyprland.nixosModules.default" to be added the host modules
        inputs.nixpkgs.follows = "nixpkgs-unstable";
      };
      nixos-cosmic = {
        url = "github:lilyinstarlight/nixos-cosmic";
        inputs.nixpkgs.follows = "nixpkgs-unstable";
      };
    };
  outputs = inputs @ { self, nixpkgs, nixpkgs-unstable, home-manager, hyprland, nixos-cosmic, ... }:   # Function telling flake which inputs to use
	let 
		vars = {                                                              # Variables Used In Flake
			user = "bocmo";
			location = "$HOME/.flake";
			terminal = "alacritty";
			editor = "vim";
      stateVersion = "24.05";
		};
	in {
		nixosConfigurations = (
			import ./hosts {
			inherit (nixpkgs) lib;
			inherit inputs nixpkgs nixpkgs-unstable home-manager hyprland nixos-cosmic vars;   # Inherit inputs
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
