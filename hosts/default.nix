{ inputs, vars, ... }:
{
  vallium = inputs.nixpkgs-unstable.lib.nixosSystem {
    # system = "x86_64-linux";
    specialArgs = {
        # inherit (inputs.nixpkgs-unstable) lib;
        inherit vars inputs;
        host = {
            hostName = "vallium";
            vars = vars;
            system = "x86_64-linux";
            gpu = "nvidia";
        };
        pkgs-stable   = import inputs.nixpkgs-stable   {system = "x86_64-linux";config.allowUnfree = true;};
        pkgs-unstable = import inputs.nixpkgs-unstable {system = "x86_64-linux";config.allowUnfree = true;};
        pkgs-master   = import inputs.nixpkgs-master   {system = "x86_64-linux";config.allowUnfree = true;};
        # system = "x86_64-linux";
    };
    modules = [
      # nur.nixosModules.nur
      ./configuration.nix
      ./vallium
      .././modules
    ];
  };
  # stealth = inputs.nixpkgs-unstable.lib.nixosSystem {
  #   system = "x86_64-linux";
  #   specialArgs = {
  #     inherit vars inputs;
  #     host = {
  #         hostName = "stealth";
  #         vars = vars;
  #         system = "x86_64-linux";
  #         gpu = "intel";
  #     };
  #     pkgs-stable   = import inputs.nixpkgs-stable   {system = "x86_64-linux";config.allowUnfree = true;};
  #     pkgs-unstable = import inputs.nixpkgs-unstable {system = "x86_64-linux";config.allowUnfree = true;};
  #     pkgs-master   = import inputs.nixpkgs-master   {system = "x86_64-linux";config.allowUnfree = true;};
  #     system = "x86_64-linux";
  #   };
  #   modules = [
  #     # nur.nixosModules.nur
  #     ./configuration.nix
  #     ./stealth
  #     .././modules
  #   ];
  # };
  dockeropen = inputs.nixpkgs-unstable.lib.nixosSystem {
    # system = "x86_64-linux";
    specialArgs = {
      inherit vars inputs;
      host = {
          hostName = "dockeropen";
          vars = vars;
          system = "x86_64-linux";
          gpu = "none";
      };
      pkgs-stable   = import inputs.nixpkgs-stable   {system = "x86_64-linux";config.allowUnfree = true;};
      pkgs-unstable = import inputs.nixpkgs-unstable {system = "x86_64-linux";config.allowUnfree = true;};
      pkgs-master   = import inputs.nixpkgs-master   {system = "x86_64-linux";config.allowUnfree = true;};
      system = "x86_64-linux";
    };
    modules = [
        # nur.nixosModules.nur
        ./configuration.nix
        ./dockeropen
        .././modules
    ];
  };
  # git = inputs.nixpkgs-stable.lib.nixosSystem {
  #   # system = "x86_64-linux";
  #   specialArgs = {
  #     inherit vars inputs;
  #     host = {
  #         hostName = "git";
  #         # taking original value from root, but overwriting the state version
  #         vars = inputs.nixpkgs-stable.lib.recursiveUpdate vars {
  #           stateVersion = "25.05";
  #         };
  #         system = "x86_64-linux";
  #         gpu = "none";
  #     };
  #     pkgs-stable   = import inputs.nixpkgs-stable   {system = "x86_64-linux";config.allowUnfree = true;};
  #     pkgs-unstable = import inputs.nixpkgs-unstable {system = "x86_64-linux";config.allowUnfree = true;};
  #     pkgs-master   = import inputs.nixpkgs-master   {system = "x86_64-linux";config.allowUnfree = true;};
  #     system = "x86_64-linux";
  #   };
  #   modules = [
  #       # nur.nixosModules.nur
  #       ./configuration.nix
  #       ./git
  #   ];
  # };
  zbook-max395 = inputs.nixpkgs-stable.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {
      inherit vars inputs;
      host = {
          hostName = "zbook-max395";
          vars = inputs.nixpkgs-stable.lib.recursiveUpdate vars {
            stateVersion = "25.05";
          };
          system = "x86_64-linux";
          gpu = "amd";
      };
      pkgs-stable   = import inputs.nixpkgs-stable   {system = "x86_64-linux";config.allowUnfree = true;};
      pkgs-unstable = import inputs.nixpkgs-unstable {system = "x86_64-linux";config.allowUnfree = true;};
      pkgs-master   = import inputs.nixpkgs-master   {system = "x86_64-linux";config.allowUnfree = true;};
      system = "x86_64-linux";
    };
    modules = [
      # nur.nixosModules.nur
      ./configuration.nix
      ./zbook-max395
      .././modules
    ];
  };
  networktest = inputs.nixpkgs-unstable.lib.nixosSystem {
    # system = "x86_64-linux";
    specialArgs = {
      inherit vars inputs;
      host = {
          hostName = "networktest";
          vars = vars;
          system = "x86_64-linux";
          gpu = "none";
      };
      pkgs-stable   = import inputs.nixpkgs-stable   {system = "x86_64-linux";config.allowUnfree = true;};
      pkgs-unstable = import inputs.nixpkgs-unstable {system = "x86_64-linux";config.allowUnfree = true;};
      pkgs-master   = import inputs.nixpkgs-master   {system = "x86_64-linux";config.allowUnfree = true;};
      system = "x86_64-linux";
    };
    modules = [
        # nur.nixosModules.nur
        ./configuration.nix
        ./networktest
    ];
  };
  hydra-01 = inputs.nixpkgs-unstable.lib.nixosSystem {
    # system = "x86_64-linux";
    specialArgs = {
      inherit vars inputs;
      host = {
          hostName = "hydra-01";
          vars = vars;
          system = "x86_64-linux";
          gpu = "none";
      };
      pkgs-stable   = import inputs.nixpkgs-stable   {system = "x86_64-linux";config.allowUnfree = true;};
      pkgs-unstable = import inputs.nixpkgs-unstable {system = "x86_64-linux";config.allowUnfree = true;};
      pkgs-master   = import inputs.nixpkgs-master   {system = "x86_64-linux";config.allowUnfree = true;};
      system = "x86_64-linux";
    };
    modules = [
        # nur.nixosModules.nur
        ./configuration.nix
        ./hydra
        .././modules
    ];
  };
}
