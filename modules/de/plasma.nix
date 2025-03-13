{ config, inputs, system, vars, lib, pkgs, ... }:
let
  inherit (pkgs) kdePackages;
  # pkgs = import inputs.nixpkgs-unstable {
  #     config.allowUnfree = true;
  #     inherit system;
  # };
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
    
    services.displayManager.sddm.enable = false;
    services.displayManager.sddm.wayland.enable = false;
    services.desktopManager.plasma6 = {
      enable = true;
      enableQt5Integration = true;
    };
    programs.ssh.askPassword = mkForce "${kdePackages.ksshaskpass.out}/bin/ksshaskpass";
    # services.xserver.displayManager.sddm.enable = lib.mkDefault true;
    # services.xserver.desktopManager.plasma6.enable = true;
    environment.plasma6.excludePackages = with kdePackages; [
      # plasma-browser-integration
      # konsole
      # (lib.getBin qttools) # Expose qdbus in PATH
      # ark
      plasma-browser-integration
      konsole
      # oxygen
      elisa
      gwenview
      okular
      # kate
      khelpcenter
      # dolphin
      # dolphin-plugins
      # spectacle
      # ffmpegthumbs
      krdp
    ];
    environment = {
      systemPackages = with pkgs; [  
        # kdePackages.kdialog
      ];};
    environment.variables = {
    #   KWIN_DRM_NO_AMS=lib.mkForce "1"; ## allow tearing if enabled in settings
    };
    programs = {    
      kdeconnect = {                                    # GSConnect
        enable = lib.mkForce true;
    };
    };
    home-manager.users.${vars.user} = {
      
    };
    security.wrappers = {
      "mount.nfs" = {
        program = "mount.nfs";
        setuid = true;
        owner = "root";
        group = "root";
        source = "${pkgs.nfs-utils.out}/bin/mount.nfs";
      };
      "umount.nfs" = {
        program = "umount.nfs";
        setuid = true;
        owner = "root";
        group = "root";
        source = "${pkgs.nfs-utils.out}/bin/umount.nfs";
      };
      "mount4.nfs" = {
        program = "mount.nfs4";
        setuid = true;
        owner = "root";
        group = "root";
        source = "${pkgs.nfs-utils.out}/bin/mount.nfs4";
      };
      "umount4.nfs" = {
        program = "umount.nfs4";
        setuid = true;
        owner = "root";
        group = "root";
        source = "${pkgs.nfs-utils.out}/bin/umount.nfs4";
      };
    };
    qt = {
     enable = lib.mkForce true;
     #platformTheme = "gtk2";
     style = "breeze";
    };


    xdg.portal = {
      enable = true;
      extraPortals = [ kdePackages.xdg-desktop-portal-kde ];
      # configPackages = [pkgs.gnome-session];
    };
  };
}
