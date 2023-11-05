{
  description = "A very basic flake";

  inputs = {
	nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
	nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
	home-manager = {
		url = github:nix-community/home-manager;
		inputs.nixpkgs.follows = "nixpkgs";
	};	
};
  outputs = inputs @ { self, nixpkgs, home-manager,  ... }:
	let 
	  system = "x86_64-linux";
	  user = "bocmo";
	  pkgs = import nixpkgs { inherit system; config.allowUnfree = true;};
	  lib = nixpkgs.lib;
	in {
	  nixosConfigurations = {
		vallium1 = lib.nixosSystem { 
			inherit system; modules = [ ./configuration.nix];
	        	};
		laptop = lib.nixosSystem { 
			inherit system; modules = [ ./configuration.nix];
	        	};

	  };
	};	  
}
