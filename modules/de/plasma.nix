{ config, inputs, vars, lib, ... }:
let
    pkgs = import inputs.nixpkgs-unstable {
        config.allowUnfree = true;
        system = "x86_64-linux";
    };
in
with lib;
{
  options = {
    plasma = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config = mkIf (config.plasma.enable) {
    services.xserver.enable = true;
    # services.xserver.displayManager.gdm.enable = lib.mkForce false;
    services.xserver.displayManager.sddm.enable = lib.mkDefault true;
    services.xserver.desktopManager.plasma6.enable = true;
    hardware.bluetooth.enable = true;
    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      plasma-browser-integration
      konsole
      oxygen
    ];
    environment = {
      systemPackages = with pkgs; [  
      ];};
    environment.variables = {
      KWIN_DRM_NO_AMS=lib.mkForce "1"; ## allow tearing if enabled in settings
    };
    home-manager.users.${vars.user} = {
      
    };
  };
}
