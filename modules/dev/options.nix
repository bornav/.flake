{ config, lib, ... }:
with lib;
{
  options = {
    ide = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
      vscode = mkOption {
        type = types.bool;
        default = false;
      };
      zed = mkOption {
        type = types.bool;
        default = false;
      };
    };
    devops = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
    portainer = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
    docker = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
    ai = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
}
