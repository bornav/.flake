{
  config,
  lib,
  system,
  inputs,
  pkgs,
  pkgs-master,
  ...
}: {
  programs = {
    opencode = {
      # package = pkgs-master.opencode;
      enable = true;
      web.enable = true;
      web.extraArgs= [
        "--mdns"
        "--cors"
        "vallium.nix.internal"
        "--cors"
        "vallium.nb.internal"
        "--port" "10002"
      ];
      extraPackages = [];
    };
  };
  home.file.".config/llama-swap/config.yaml" = {
    source = ./llama-swap-config.yaml;
    force = true;
    mutable = true;
  };
  # home.file.".config/opencode/opencode.json" = {
  #   source = ./opencode-config.json;
  # };
}
