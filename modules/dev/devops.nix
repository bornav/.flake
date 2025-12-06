{ config, inputs, host, lib, pkgs, ... }:
# let
#     pkgs-stable = import inputs.nixpkgs-stable {
#         config.allowUnfree = true;
#         inherit system;
#     };
#     pkgs-unstable = import inputs.nixpkgs-unstable {
#         config.allowUnfree = true;
#         inherit system;
#     };
# in
with lib;
{
  config = mkIf (config.devops.enable) {
    environment.systemPackages = with pkgs; [
      k9s
      thttpd # htpasswd
      lazygit
      dig
      tcpdump
      yq
      flux
      fluxcd
      kubectl
      kubelogin
      kubelogin-oidc
      sops
      age
      ansible
      kubernetes-helm
      helmfile
      kubernetes-helmPlugins.helm-diff
      kustomize
      kustomize-sops
      # lens
      bfg-repo-cleaner
      inetutils
      cilium-cli
      kind
      yaml-language-server  # TODO look into
      inputs.compose2nix.packages.x86_64-linux.default
      ];
    home-manager = {
      backupFileExtension = "backup";
      extraSpecialArgs = {inherit inputs;};
      users.${host.vars.user} =  lib.mkMerge [
        (import ./home-mutable-k9s.nix)
      ];
    };


      # programs.k9s = {
      #   enable = true;
      #   settings = {
      #     k9s = {
      #       liveViewAutoRefresh = true;
      #       screenDumpDir = "/home/${vars.user}/.local/state/k9s/screen-dumps";
      #       refreshRate = 1;
      #       maxConnRetry = 5;
      #       readOnly = false;
      #       noExitOnCtrlC = false;
      #       ui = {
      #         enableMouse = false;
      #         headless = false;
      #         logoless = true;
      #         crumbsless = false;
      #         reactive = true;
      #         noIcons = false;
      #       };
      #       skipLatestRevCheck = true;
      #       disablePodCounting = false;
      #       shellPod = {
      #         image = "busybox:1.35.0";
      #         namespace = "default";
      #         limits = {
      #           cpu = "100m";
      #           memory = "100Mi";
      #         };
      #       };
      #       imageScans = {
      #         enable = false;
      #         exclusions = {
      #           namespaces = [ ];
      #           labels = { };
      #         };
      #       };
      #       logger = {
      #         tail = 1000;
      #         buffer = 5000;
      #         sinceSeconds = -1;
      #         fullScreenLogs = false;
      #         textWrap = false;
      #         showTime = false;
      #       };
      #       featureGates = {
      #         nodeShell = true;
      #       };
      #       thresholds = {
      #         cpu = {
      #           critical = 90;
      #           warn = 70;
      #         };
      #         memory = {
      #           critical = 90;
      #           warn = 70;
      #         };
      #       };
      #     };
      #   };
      # };

  };
}
