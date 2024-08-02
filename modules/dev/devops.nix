{ config, inputs, vars, lib, ... }:
let
    pkgs = import inputs.nixpkgs-unstable {
        config.allowUnfree = true;
        system = "x86_64-linux";
    };
in
with lib;
{
  config = mkIf (config.devops.enable) {
    environment.systemPackages = with pkgs; [
      flux
      fluxcd
      kubectl
      sops
      age
      ansible
      kubernetes-helm
      kustomize
      kustomize-sops
      lens
      bfg-repo-cleaner
      inetutils
      dig
      k9s
      yaml-language-server  # TODO look into
      nil # TODO move into ide
      inputs.compose2nix.packages.x86_64-linux.default
      thttpd # htpasswd
    ];
    # environment.systemPackages = [
    #   compose2nix.packages.x86_64-linux.default
    # ];
    virtualisation.docker.enable = true;
  };
}
