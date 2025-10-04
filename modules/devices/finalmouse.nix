{ config, inputs, system, vars, lib, pkgs,  ... }:
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
      finalmouse = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config = mkIf (config.device.finalmouse) {
    services.udev.packages = [
    (pkgs.writeTextFile {
      name = "finalmouse_udev";
      text = ''
        SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="361d", ATTR{idProduct}=="0100", MODE="0666"
        SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="361d", ATTR{idProduct}=="0101", MODE="0666"
        SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="361d", ATTR{idProduct}=="0102", MODE="0666"
        SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="361d", ATTR{idProduct}=="0103", MODE="0666"
        SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="361d", ATTR{idProduct}=="0111", MODE="0666"

        KERNEL=="hidraw*", ATTRS{idVendor}=="361d", ATTRS{idProduct}=="0100", MODE="0666"
        KERNEL=="hidraw*", ATTRS{idVendor}=="361d", ATTRS{idProduct}=="0101", MODE="0666"
        KERNEL=="hidraw*", ATTRS{idVendor}=="361d", ATTRS{idProduct}=="0102", MODE="0666"
      '';
      destination = "/etc/udev/rules.d/99-finalmouse.rules";
    })
  ];};
}
