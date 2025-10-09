{ config, inputs, host, system, lib, pkgs, ... }:
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
      # enableQt5Integration = lib.mkForce false; # true by default
    };
    programs.ssh.askPassword = mkForce "${kdePackages.ksshaskpass.out}/bin/ksshaskpass";
    # services.xserver.displayManager.sddm.enable = lib.mkDefault true;
    # services.xserver.desktopManager.plasma6.enable = true;
    environment.plasma6.excludePackages = [
      # plasma-browser-integration
      # konsole
      # (lib.getBin qttools) # Expose qdbus in PATH
      # ark
      pkgs.kdePackages.plasma-browser-integration
      pkgs.kdePackages.konsole
      # oxygen
      pkgs.kdePackages.elisa
      pkgs.kdePackages.gwenview
      pkgs.kdePackages.okular
      # kate
      pkgs.kdePackages.khelpcenter
      # dolphin
      # dolphin-plugins
      # spectacle
      # ffmpegthumbs
      pkgs.kdePackages.krdp


      # pkgs.kdePackages.kwallet
      # pkgs.kdePackages.kwallet-pam # provides helper service
      # pkgs.kdePackages.kwalletmanager
    ];
    environment = {
      systemPackages = with pkgs; [
        # kdePackages.kdialog
        kdePackages.kcalc # Calculator
        kdePackages.kcharselect # Tool to select and copy special characters from all installed fonts
        kdePackages.kolourpaint # Easy-to-use paint program
        kdePackages.ksystemlog # KDE SystemLog Application
        kdePackages.kfind
        kdePackages.breeze-icons
        kdePackages.breeze-gtk
        kdePackages.kde-gtk-config
        kdePackages.xdg-desktop-portal-kde
        kdePackages.dolphin
        kdePackages.ark
        kdePackages.kate
        kdePackages.filelight
        # wayland-utils # Wayland utilities
        # wl-clipboard # Command-line copy/paste utilities for Wayland
      ];};
    environment.variables = {
    #   KWIN_DRM_NO_AMS=lib.mkForce "1"; ## allow tearing if enabled in settings
    };
    programs = {
      kdeconnect = {                                    # GSConnect
        enable = lib.mkForce true;
    };
    };
    # home-manager.users.${vars.user} = {

    # };

    home-manager = {
      backupFileExtension = "backup";
      extraSpecialArgs = {inherit inputs;};
      users.${host.vars.user} =  lib.mkMerge [
        (import ./plasma_config.nix)
        # (import ../../modules/home-manager/mutability.nix)
        # (import ./home-mutable.nix)
      ];
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
  # security.pam.services = {
  #     login.kwallet = {
  #       enable = lib.mkForce false;
  #       # package = kdePackages.kwallet-pam;
  #     };
  #     kde = {
  #       # allowNullPassword = true;
  #       kwallet = {
  #         enable = lib.mkForce false;
  #         # package = kdePackages.kwallet-pam;
  #       };
  #     };
  #     # kde-fingerprint = lib.mkIf config.services.fprintd.enable { fprintAuth = true; };
  #     # kde-smartcard = lib.mkIf config.security.pam.p11.enable { p11Auth = true; };
  #   };

  };
}
