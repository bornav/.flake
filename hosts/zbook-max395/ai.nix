{
  config,
  lib,
  system,
  inputs,
  host,
  pkgs,
  pkgs-unstable,
  pkgs-master,
  ...
}:
# TODO remove system, only when from all modules it is removed
{
  boot.kernelParams = [
    "ttm.pages_limit=${toString (55*1024*1024*1024/(1024*4))}" #(GB×1024×1024×1024)/(4×1024)
  ];

  services.ollama = {
    enable = false;
    package = pkgs-master.ollama-vulkan;
    # acceleration = "rocm";
    openFirewall = true;
    # rocmOverrideGfx = "11.0.0";
  };
  environment.systemPackages = [
    pkgs.radeontop
    pkgs.amd-debug-tools
    pkgs.nvtopPackages.amd
    pkgs.llama-cpp-vulkan
    pkgs.opencode

    # pkgs.openshell
    pkgs.pi-coding-agent
    pkgs.sqlite
    pkgs.libkrun
  ];

  # systemd.user.services.
  systemd.services.llama-swap = {
    description = "Llama Swap - OpenAI Compatible Proxy";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];
    enable = true;
    serviceConfig = {
      Type = "simple";
      User = "${host.vars.user}";
      Group = "users";
      # WorkingDirectory = "/home/user/workspace/llama-swap";
      ExecStart = "${pkgs.llama-swap}/bin/llama-swap -config /home/${host.vars.user}/.config/llama-swap/config.yaml --listen 0.0.0.0:10001 -watch-config";
      Restart = "always";
      RestartSec = "5";
      StandardOutput = "journal";
      StandardError = "journal";
    };
    # StartLimit directives belong in [Unit], not [Service]
    unitConfig = {
      StartLimitBurst = "3";
      StartLimitIntervalSec = "30"; # systemd uses IntervalSec, not Interval
    };
  };

  home-manager = {
    backupFileExtension = "backup";
    extraSpecialArgs = {inherit inputs;};
    users.${host.vars.user} = {
      home.file.".config/llama-swap/config.yaml" = {
        source = ./llama-swap-config.yaml;
        # force = true;
        # mutable = true;
      };
      home.file.".config/opencode/opencode.json" = {
        source = ./opencode-config.json;
        # force = true;
        # mutable = true;
      };

      programs = {
        opencode = {
          # package = pkgs-master.opencode;
          enable = true;
          web.enable = true;
          web.extraArgs= [
            "--mdns"
            "--cors"
            "zbook-max395.nix.internal"
          ];
          extraPackages = [];
        };
      };
    };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [11434 10001 4096];
    allowedUDPPorts = [11434 10001];
  };
}
