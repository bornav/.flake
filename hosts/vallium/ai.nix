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
  nixpkgs.overlays = [
    inputs.llm-agents.overlays.shared-nixpkgs
  ];

  environment.systemPackages = [
    pkgs.llama-cpp-cuda
    pkgs.aichat
    pkgs.nodejs # for npm and so on

    # pkgs-unstable.opencode
    pkgs.pi-coding-agent

    pkgs.libcap_ng #this here to fix openshell vm driver

    # pkgs.vllm

    pkgs.llm-agents.pi
    pkgs.llm-agents.dsh
    pkgs.llm-agents.opencode
    # pkgs.llm-agents.opencode2
    pkgs.llm-agents.qwen-code
  ];
  programs.nix-ld = {
    #this here to fix openshell vm driver
    enable = true;
    libraries = with pkgs; [
      libcap_ng
    ];
  };
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [11434 10002 10001 10000];
    allowedUDPPorts = [11434 10002 10001 10000];
  };

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
    extraSpecialArgs = {inherit inputs pkgs-master;};
    users.${host.vars.user} = lib.mkMerge [
      (import ./ai-home.nix)
    ];
  };

  # dsh deepseek harness
  # systemd.user.services.
  systemd.services.dsh = {
    description = "Deepseek harness";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];
    enable = true;
    serviceConfig = {
      Type = "simple";
      User = "${host.vars.user}";
      Group = "users";
      # WorkingDirectory = "/home/user/workspace/llama-swap";
      ExecStart = "${pkgs.llm-agents.dsh}/bin/dsh --profile web --port 10000";
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

  # systemd.services.openshell-gateway = {
  #   description = "OpenShell gateway (local, VM driver)";
  #   documentation = [ "https://docs.nvidia.com/openshell/" ];
  #   wantedBy = [ "default.target" ];
  #   after = [ "network-online.target" ];
  #   wants = [ "network-online.target" ];
  #   serviceConfig = {
  #     Type = "simple";
  #     User = "user"; # Change to your username if running as user
  #     Group = "users";
  #     # Environment variables
  #     Environment = [ "OPENSHELL_LOG_LEVEL=info" ];
  #     # ExecStart: Replace /var/lib/openshell with the actual home dir if different
  #     # Note: You need to ensure 'openshell-gateway' is in pkgs or defined elsewhere
  #     ExecStart = ''
  #       /home/user/.local/bin/openshell-gateway \
  #         --bind-address 127.0.0.1 \
  #         --port 8085 \
  #         --disable-tls \
  #         --db-url sqlite:///home/user/.local/share/openshell/db.sqlite \
  #         --drivers vm \
  #         --driver-dir /home/user/.local/libexec/openshell \
  #         --vm-driver-state-dir /home/user/.local/share/openshell/vm \
  #         --grpc-endpoint http://host.containers.internal:8085
  #     '';
  #     Restart = "on-failure";
  #     RestartSec = 3;
  #     # Sandboxing options (mapped from original)
  #     NoNewPrivileges = true;
  #     ProtectSystem = "strict";
  #     ReadWritePaths = [
  #       "/home/user/.local/share/openshell"
  #       "/tmp" # %t is typically /tmp or a private tmpfs in systemd, but NixOS handles PrivateTmp below
  #     ];
  #     ProtectHome = "read-only";
  #     PrivateTmp = true;
  #     # # Additional NixOS-specific hardening (optional but recommended)
  #     # ProtectKernelTunables = true;
  #     # ProtectControlGroups = true;
  #     # RestrictSUIDSGID = true;
  #     # SystemCallFilter = [ "@system-service" ];
  #   };
  # };
}
