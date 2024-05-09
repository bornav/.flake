{ lib, config, pkgs, pkgs-unstable, vars, ... }:
with lib;
{
  options = {
    ai = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config = mkIf (config.ai.enable) {
    environment.systemPackages = with pkgs; [
        ollama
        # lmstudio
        gpt4all
        # tabby
        # nvidia-container-toolkit # TODO breaks normal docker(overwrites)
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
