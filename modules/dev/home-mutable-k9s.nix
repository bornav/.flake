# this file depends on mutability.nix file to be imported from home-manager user level, it adds force and mutable fields
{inputs, config, pkgs, ... }:
{
# imports = [
#     import ../mutability.nix
#     # possibly other imports
#   ];
# home.file."asdasd.sh".source =
# let
#   script = pkgs.writeShellScriptBin "asdasd.sh" ''
#     asd
#   '';
# in
#   "${script}/bin/testscript.sh" ;
home.file.".config/k9s/config.yaml" = {
  text = ''
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
    screenDumpDir: /home/user/.local/state/k9s/screen-dumps # here all the files are stored  /home/user/.local/share/k9s/clusters
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
  force = true;
  mutable = true;
  };
}
