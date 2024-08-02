{ config, inputs, system, vars, lib, ... }:
let
    pkgs = import inputs.nixpkgs-unstable {
        config.allowUnfree = true;
        inherit system;
    };
in
with lib;
{

  config = mkIf (config.ai.enable) {
    environment.systemPackages = with pkgs; [
        # ollama
        # lmstudio
        # gpt4all
        # tabby
        # nvidia-container-toolkit # TODO breaks normal docker(overwrites)
        onnxruntime
      ];
    # services.tabby.enable = true;

    # virtualisation.containers.cdi.dynamic.nvidia.enable = true;
    hardware.nvidia-container-toolkit.enable = true;
    virtualisation.docker.enableNvidia = true;
    networking.firewall = {
      enable = true;
      allowedTCPPorts = [ 8080 ];
      allowedUDPPorts = [ 8080 ];
    };
  };
}
