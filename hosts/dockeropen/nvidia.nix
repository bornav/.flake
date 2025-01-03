{ config, lib, host, inputs, ... }:
let
  pkgs = import inputs.nixpkgs-unstable {
    system = host.system;
    config.allowUnfree = true;
  };
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = host.system;
    config.allowUnfree = true;
  };
in
{
  nixpkgs.config.allowUnfree = true;
  hardware = {
    nvidia = {
      modesetting.enable = true;
      open = false;
      nvidiaSettings = true;
      package = lib.mkForce config.boot.kernelPackages.nvidiaPackages.latest;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
    };
    graphics.enable32Bit = true;
    graphics.enable = true;
  };
}
