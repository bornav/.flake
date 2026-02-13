{
  config,
  lib,
  ...
}:
with lib; {
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
      zed = {
        enable = mkOption {
          type = types.bool;
          default = false;
        };
        language = {
          #https://zed.dev/docs/languages
          go = mkOption {
            type = types.bool;
            default = false;
          };
          rust = mkOption {
            type = types.bool;
            default = false;
          };
          nodejs = mkOption {
            type = types.bool;
            default = false;
          };
          python = mkOption {
            type = types.bool;
            default = false;
          };
          yaml = mkOption {
            type = types.bool;
            default = false;
          };
          docker = mkOption {
            type = types.bool;
            default = false;
          };
          nix = mkOption {
            type = types.bool;
            default = false;
          };
          java = mkOption {
            type = types.bool;
            default = false;
          };
        };
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
    podman = {
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
