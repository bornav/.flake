{ config, lib, ... }:
with lib;
{
  options = {
    steam = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
    emulation = {
      switch = mkOption {
        type = types.bool;
        default = false;
      };
    };
    games.applications = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
}
