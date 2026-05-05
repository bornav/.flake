{ config, inputs, system, vars, lib, pkgs, ... }:
# let
#     pkgs = import inputs.nixpkgs-unstable {
#         config.allowUnfree = true;
#         inherit system;
#     };
# in
with lib;
{
  options = {
    device = {
      orbital-pathfinder = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config = mkIf (config.device.orbital-pathfinder) {
   services.udev.packages = [
    (pkgs.writeTextFile {
      name = "pathfinder_udev";
      text = ''
        # orbital-pathfinder
        SUBSYSTEM=="usb", ATTRS{idVendor}=="1915", ATTRS{idProduct}=="0746", MODE="0666"
        SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1915", ATTRS{idProduct}=="0746", MODE="0666"

        SUBSYSTEM=="usb", ATTRS{idVendor}=="1915", ATTRS{idProduct}=="0747", MODE="0666"
        SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1915", ATTRS{idProduct}=="0747", MODE="0666"
      '';
      destination = "/etc/udev/rules.d/99-orbital-pathfinder.rules";
    })
  ];};
  }
