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
      akko = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config = mkIf (config.device.akko) {
   services.udev.packages = [
    (pkgs.writeTextFile {
      name = "akko_udev";
      text = ''
        # Generic Wootings
        SUBSYSTEM=="hidraw", ATTRS{idVendor}=="38ee", TAG+="uaccess"
        SUBSYSTEM=="usb", ATTRS{idVendor}=="38ee", TAG+="uaccess"
      '';
      destination = "/etc/udev/rules.d/70-akko.rules";
    })
  ];};
  }
