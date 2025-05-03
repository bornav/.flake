{ config, inputs, host, lib, pkgs, pkgs-stable, pkgs-unstable, ... }:
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
    environment.systemPackages = [(
      pkgs-unstable.k9s
    )] ++(with pkgs-stable; [
      thttpd # htpasswd
      lazygit
      dig
      tcpdump
      yq
    ]) ++
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
      nil # TODO move into ide
      inputs.compose2nix.packages.x86_64-linux.default
    ]);
    home-manager.users.${host.vars.user} = {
      home.file.".config/k9s/config.yaml".text = 
      ''
      k9s:
        disablePodCounting: false
        # featureGates: # this should be done inside .local.share/k9s/context...
        #   nodeShell: true
        imageScans:
          enable: false
          exclusions:
            labels: {}
            namespaces: []
        liveViewAutoRefresh: true
        logger:
          tail: 1000
          buffer: 5000
          showTime: false
          sinceSeconds: -1
          textWrap: false
        maxConnRetry: 5
        noExitOnCtrlC: false
        readOnly: false
        refreshRate: 1
        screenDumpDir: /home/bocmo/.local/state/k9s/screen-dumps # here all the files are stored
        shellPod:
          image: busybox:1.35.0
          limits:
            cpu: 100m
            memory: 100Mi
          namespace: default
        skipLatestRevCheck: true
        thresholds:
          cpu:
            critical: 90
            warn: 70
          memory:
            critical: 90
            warn: 70
        defaultView: "" # LOOK INTO
        ui:
          enableMouse: false
          crumbsless: false
          headless: false
          logoless: true
          noIcons: false
          reactive: true
      '';


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
  };
}
