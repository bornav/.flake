{ inputs, vars, ... }:
{
  vallium = inputs.nixpkgs-unstable.lib.nixosSystem {
    # system = "x86_64-linux";  
    specialArgs = {
        # inherit (inputs.nixpkgs-unstable) lib;
        inherit  vars inputs;
        host = {
            hostName = "vallium";
            vars = vars;
            system = "x86_64-linux"; 
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
    ];
  };
  stealth = inputs.nixpkgs-unstable.lib.nixosSystem {
    system = "x86_64-linux";  
    specialArgs = {
      inherit  vars inputs;
      host = {
          hostName = "stealth";
          vars = vars;
          system = "x86_64-linux"; 
      };
      pkgs-stable   = import inputs.nixpkgs-stable   {system = "x86_64-linux";config.allowUnfree = true;};
      pkgs-unstable = import inputs.nixpkgs-unstable {system = "x86_64-linux";config.allowUnfree = true;};
      pkgs-master   = import inputs.nixpkgs-master   {system = "x86_64-linux";config.allowUnfree = true;};
      system = "x86_64-linux"; 
    };
    modules = [
      # nur.nixosModules.nur
      ./configuration.nix
      ./stealth
      
    ];
  };
  dockeropen = inputs.nixpkgs-unstable.lib.nixosSystem {
    # system = "x86_64-linux";  
    specialArgs = {
      inherit vars inputs;
      host = {
          hostName = "dockeropen";
          vars = vars;
          system = "x86_64-linux"; 
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
    ];
  };
  lighthouse = inputs.nixpkgs-unstable.lib.nixosSystem {
    # system = "x86_64-linux";  
    specialArgs = {
      inherit vars inputs;
      host = {
          hostName = "lighthouse-ubuntu-4gb-nbg1-2";
          vars = vars;
          system = "x86_64-linux"; 
      };
      pkgs-stable   = import inputs.nixpkgs-stable   {system = "x86_64-linux";config.allowUnfree = true;};
      pkgs-unstable = import inputs.nixpkgs-unstable {system = "x86_64-linux";config.allowUnfree = true;};
      pkgs-master   = import inputs.nixpkgs-master   {system = "x86_64-linux";config.allowUnfree = true;};
      system = "x86_64-linux"; 
    };
    modules = [
        # nur.nixosModules.nur
        # ./configuration.nix
        ./lighthouse
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
}
