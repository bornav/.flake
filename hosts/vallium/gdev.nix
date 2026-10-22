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

  # godot wrapper: starts godot-mcp (stdio server, exposed over HTTP via mcp-proxy) when Godot starts, tears it down when Godot exits
  # GODOT_PATH pins the real godot so godot-mcp's own godot calls don't loop back into this wrapper
  godot-with-mcp = pkgs.writeShellScriptBin "godot" ''
    set -u
    UNIT="godot-mcp"

    systemd-run --user --collect --unit="$UNIT" \
      --description="Godot MCP server (tied to Godot lifetime)" \
      ${pkgs.mcp-proxy}/bin/mcp-proxy --host 0.0.0.0 --port 9192 \
        -e GODOT_PATH ${pkgs-unstable.godot_4_7}/bin/godot \
        -- ${pkgs-unstable.godot-mcp}/bin/godot-mcp
    echo "godot-mcp: started"

    ${pkgs-unstable.godot_4_7}/bin/godot "$@"
    status=$?

    systemctl --user stop "$UNIT" 2>/dev/null || true
    echo "godot-mcp: stopped"
    exit $status
  '';
in
{
  nixpkgs.overlays = [
    inputs.llm-agents.overlays.shared-nixpkgs
  ];

  environment.systemPackages = [
    blender-with-mcp
    godot-with-mcp
    pkgs-unstable.godot-mcp
  ];
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [9191 9876 9192];
    # allowedUDPPorts = [11434 10002 10001 10000];
  };

  # home-manager = {
  #   backupFileExtension = "backup";
  #   extraSpecialArgs = {inherit inputs pkgs-master;};
  #   users.${host.vars.user} = lib.mkMerge [
  #     (import ./ai-home.nix)
  #   ];
  # };

  # replaces the stock godot .desktop entry (which execs the raw store path, bypassing the wrapper)
  home-manager.users.${host.vars.user} = {
    xdg.desktopEntries."org.godotengine.Godot4.7" = {
      name = "Godot Engine 4.7";
      genericName = "Libre game engine";
      comment = "Multi-platform 2D and 3D game engine with a feature-rich editor";
      exec = "${godot-with-mcp}/bin/godot %f";
      icon = "${pkgs-unstable.godot_4_7}/share/icons/godot.png";
      categories = [ "Development" "IDE" ];
      mimeType = [ "application/x-godot-project" ];
      settings.StartupWMClass = "Godot";
    };
  };
}
