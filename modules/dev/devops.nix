{ config, inputs, system, vars, lib, ... }:
let
    pkgs = import inputs.nixpkgs-unstable {
        config.allowUnfree = true;
        inherit system;
    };
in
with lib;
{
  config = mkIf (config.devops.enable) {
    environment.systemPackages = with pkgs; [
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
      lazygit
      # lens
      bfg-repo-cleaner
      inetutils
      dig
      k9s
      tcpdump
      yq
      yaml-language-server  # TODO look into
      nil # TODO move into ide
      inputs.compose2nix.packages.x86_64-linux.default
      thttpd # htpasswd
    ];
  };
}
