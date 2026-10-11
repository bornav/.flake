{
  config,
  lib,
  system,
  inputs,
  host,
  pkgs,
  pkgs-unstable,
  pkgs-master,
  pkgs-custom,
  ...
}: {
  nixpkgs.overlays = [
    inputs.llm-agents.overlays.shared-nixpkgs
  ];

  environment.systemPackages = [
    pkgs-unstable.blender
    pkgs-unstable.godot_4_7
  ];
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [9191 9876];
    # allowedUDPPorts = [11434 10002 10001 10000];
  };

  # home-manager = {
  #   backupFileExtension = "backup";
  #   extraSpecialArgs = {inherit inputs pkgs-master;};
  #   users.${host.vars.user} = lib.mkMerge [
  #     (import ./ai-home.nix)
  #   ];
  # };
}
