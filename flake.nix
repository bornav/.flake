{
  description = "A very basic flake";
  inputs = {
    # nix-pkgs-local.url = "git+file:////home/user/git/nixpkgs-custom";
    nix-pkgs-local.url = "git+file:////home/user/git/nixpkgs";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";         # Unstable Nix Packages
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixpkgs-6-16-kernel.url = "github:nixos/nixpkgs/c86b434e0f777e57642eb573d003e7c72b73b0a2";
    nixpkgs-bornav.url = "github:bornav/nixpkgs/headscale-restart-fix";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master"; #https://github.com/NixOS/nixos-hardware/tree/master
    home-manager = {url = "github:nix-community/home-manager";
                    # inputs.nixpkgs.follows = "nixpkgs-stable";
                    };
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    hyprland = {url = "github:hyprwm/Hyprland";                                     # Requires "hyprland.nixosModules.default" to be added the host modules
                # inputs.nixpkgs.follows = "nixpkgs-unstable";
                };
    nixos-cosmic = {url = "github:lilyinstarlight/nixos-cosmic";
                    # inputs.nixpkgs.follows = "nixpkgs-unstable";
                    };
    nur.url = "github:nix-community/NUR";
    disko = {url = "github:nix-community/disko";
            #  inputs.nixpkgs.follows = "nixpkgs-unstable";
              };
    compose2nix = {url = "github:aksiksi/compose2nix";
                  #  inputs.nixpkgs.follows = "nixpkgs-unstable";
                    };
    wirenix.url = "sourcehut:~msalerno/wirenix";
    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";
    lanzaboote.url = "github:nix-community/lanzaboote/v0.4.2";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs-unstable";
    plasma-manager = {
        url = "github:nix-community/plasma-manager";
        inputs.home-manager.follows = "home-manager";
        # inputs.nixpkgs.follows = "nixpkgs";
      };
    flox = {
          url = "github:flox/flox/latest";
        };
  };
  outputs = { self, ... } @ inputs:   # Function telling flake which inputs to use
	let
		vars = {                                                              # Variables Used In Flake
			user = "user";
			location = "$HOME/.flake";
			terminal = "alacritty";
			editor = "vim";
      stateVersion = "26.05";
		};
    inherit (self) outputs;
	in {
		nixosConfigurations = (
			import ./hosts {
			inherit inputs outputs self vars;   # Inherit inputs
			}
		);
		hydraJobs = import ./hydra.nix {inherit inputs outputs;};
		# homeConfigurations = (
		# 	import ./nix {
		# 	inherit (nixpkgs) lib;
		# 	inherit inputs nixpkgs nixpkgs-unstable home-manager vars;
		# 	}
		# );
	};
}
