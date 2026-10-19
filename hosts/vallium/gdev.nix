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
}:
let
  blender-mcp-image = "harbor.icylair.com/library/blender-mcp-containerized:v1.0.3";

  # blender wrapper: starts the MCP container when Blender starts, tears it down when Blender exits
  blender-with-mcp = pkgs.writeShellScriptBin "blender" ''
    set -u
    UNIT="blender-mcp"

    systemd-run --user --collect --unit="$UNIT" \
      --description="Blender MCP server (tied to Blender lifetime)" \
      ${pkgs.docker}/bin/docker run --rm --network host \
        -e MCP_TRANSPORT=http \
        -e MCP_HOST=0.0.0.0 \
        -e MCP_PORT=9191 \
        -e BLENDER_MCP_HOST=127.0.0.1 \
        -e BLENDER_MCP_PORT=9876 \
        ${blender-mcp-image}
    echo "blender-mcp: started"

    ${pkgs-unstable.blender}/bin/blender "$@"
    status=$?

    systemctl --user stop "$UNIT" 2>/dev/null || true
    echo "blender-mcp: stopped"
    exit $status
  '';
in
{
  nixpkgs.overlays = [
    inputs.llm-agents.overlays.shared-nixpkgs
  ];

  environment.systemPackages = [
    blender-with-mcp
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
