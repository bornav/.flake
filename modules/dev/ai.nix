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
        lmstudio
        gpt4all
      ];
  };
}
