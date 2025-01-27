{ config, inputs, system, vars, lib, ... }:
let
    pkgs-stable = import inputs.nixpkgs-stable {
        config.allowUnfree = true;
        inherit system;
    };
    pkgs-unstable = import inputs.nixpkgs-unstable {
        config.allowUnfree = true;
        inherit system;
    };
in
with lib;
{
  config = mkIf (config.devops.enable) {
    environment.systemPackages = with pkgs-stable; [
      thttpd # htpasswd
      lazygit
      dig
      tcpdump
      yq
    ] ++
    (with pkgs-unstable; [
      flux
      fluxcd
      kubectl
      kubelogin
      kubelogin-oidc
      sops
      age
      ansible
      kubernetes-helm
      kustomize
      kustomize-sops
      # lens
      bfg-repo-cleaner
      inetutils
      k9s
      cilium-cli
      yaml-language-server  # TODO look into
      nil # TODO move into ide
      inputs.compose2nix.packages.x86_64-linux.default
    ]);
  };
}
