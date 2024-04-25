#
#  Gnome Configuration
#  Enable with "gnome.enable = true;"
#

{ config, lib, pkgs, vars, ... }:

with lib;
{
  options = {
    gnome = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config = mkIf (config.gnome.enable) {
    programs = {
      zsh.enable = true;
      kdeconnect = {                                    # GSConnect
        enable = true;
        package = pkgs.gnomeExtensions.gsconnect;
      };
    };
    services = {
      xserver = {
        enable = true;
        # layout = "us";
        xkb.layout = "us";
        # xkbOptions = "eurosign:e";
        # libinput.enable = true;
        # modules = [ pkgs.xf86_input_wacom ];
        # wacom.enable = true;
        displayManager.gdm.enable = true;               # Display Manager
        displayManager.gdm.autoSuspend = false;
        desktopManager.gnome.enable = true;             # Desktop Environment
      };
      udev.packages = with pkgs; [
        gnome.gnome-settings-daemon
      ];
    };
    environment = {
      systemPackages = with pkgs; [                     # System-Wide Packages
        gnome.adwaita-icon-theme
        gnome.dconf-editor
        gnome.gnome-tweaks
      ];
      gnome.excludePackages = (with pkgs; [             # Ignored Packages
        gnome-tour
      ]) ++ (with pkgs.gnome; [
        gnome-contacts
        gnome-initial-setup
        hitori
        iagno
        tali
        yelp
        cheese # webcam tool
        gnome-music
        gnome-terminal
        # gedit # text editor
        epiphany # web browser
        geary # email reader
        evince # document viewer
        gnome-characters
        totem # video player
        tali # poker game
        iagno # go game
        hitori # sudoku game
        atomix # puzzle game
        nautilus
      ]);
    };

    home-manager.users.${vars.user} = {
      dconf.settings = {
        "org/gnome/shell" = {
          favorite-apps = [
            "org.gnome.settings.desktop"
            "alacritty.desktop"
          ];
          disable-user-extensions = false;
          enabled-extensions = [
            "trayiconsreloaded@selfmade.pl"
            "clipboard-indicator@tudmotu.com"
            "just-perfection-desktop@just-perfection"
          ];
        };

        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          enable-hot-corners = false;
          clock-show-weekday = true;
          gtk-theme = "adwaita-dark";
        };
        "org/gnome/desktop/privacy" = {
          report-technical-problems = "false";
        };
        "org/gnome/desktop/wm/keybindings" = {
          switch-to-workspace-1 = ["<super>1"];
          switch-to-workspace-2 = ["<super>2"];
          switch-to-workspace-3 = ["<super>3"];
          switch-to-workspace-4 = ["<super>4"];
          switch-to-workspace-5 = ["<super>5"];
          switch-to-workspace-6 = ["<super>6"];
          switch-to-workspace-7 = ["<super>7"];
          switch-to-workspace-8 = ["<super>8"];
          switch-to-workspace-9 = ["<super>9"];
          switch-to-workspace-10 = ["<super>0"];
          close = ["<super>q" "<alt>f4"];
        };
        "org/gnome/settings-daemon/plugins/power" = {
          sleep-interactive-ac-type = "nothing";
        };
        "org/gnome/settings-daemon/plugins/media-keys" = {
          custom-keybindings = [
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
          ];
        };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
          binding = "<super>t";
          command = "alacritty";
          name = "open-terminal";
        };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
          binding = "<super>e";
          command = "dolphin";
          name = "open-file-browser";
        };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
          binding = "<super>b";
          # command = ''sh -c "thorium $(cat /home/bocmo/.config/thorium-flags.conf) \"$@\""'';
          command = ''sh -c "thorium $(cat ~/.config/thorium-flags.conf) \"$@\""'';
          name = "open-web-browser";
        };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
          binding = "<ctrl><alt>Escape";
          command = "xkill";
          name = "xkill";
        };
        "org/gnome/shell/extensions/clipboard-indicator" = {
          history-size = 100;
          toggle-menu = ["<Super>v"];
        };
        "org/gnome/shell/extensions/just-perfection" = {
          theme = true;
          activities-button = true;
          app-menu = false;
          clock-menu-position = 1;
          clock-menu-position-offset = 7;
        };
      };
      home.packages = with pkgs.gnomeExtensions; [
        tray-icons-reloaded
        clipboard-indicator
        just-perfection
      ];
    };
  };
}