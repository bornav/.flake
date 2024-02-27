{ config, lib, pkgs, pkgs-unstable, vars, ... }:

with lib;
{
  options = {
    cosmic-desktop = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config = mkIf (config.cosmic-desktop.enable) {
    programs = {
      zsh.enable = true;
      
    };
    services = {
    #   xserver = {
    #     enable = true;
    #   };
    };
    environment = {
      systemPackages = with pkgs-unstable; [
        cosmic-applets
        cosmic-applibrary
        cosmic-bg
        cosmic-comp
        cosmic-icons
        cosmic-launcher
        cosmic-notifications
        cosmic-osd
        cosmic-panel
        cosmic-session
        cosmic-settings 
        cosmic-settings-daemon
        cosmic-workspaces-epoch 
        xdg-desktop-portal-cosmic
        cosmic-greeter
        cosmic-protocols
        cosmic-edit 
        cosmic-screenshot 
        cosmic-design-demo 
        cosmic-term
        cosmic-randr
        cosmic-files 
      ]; 
  };
}