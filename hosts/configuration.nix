{ config, pkgs, pkgs-unstable, vars, ... }:

{
  imports = ( import ../modules/shell ++
              import ../modules/terminalEmulators ++
              import ../modules/de);
  # thorium-browser = ;
  time.timeZone = "Europe/Vienna";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_AT.UTF-8";
    LC_IDENTIFICATION = "de_AT.UTF-8";
    LC_MEASUREMENT = "de_AT.UTF-8";
    LC_MONETARY = "de_AT.UTF-8";
    LC_NAME = "de_AT.UTF-8";
    LC_NUMERIC = "de_AT.UTF-8";
    LC_PAPER = "de_AT.UTF-8";
    LC_TELEPHONE = "de_AT.UTF-8";
    LC_TIME = "de_AT.UTF-8";
  };

  environment = {
    variables = {                           # Environment Variables
      TERMINAL = "${vars.terminal}";
      EDITOR = "${vars.editor}";
      VISUAL = "${vars.editor}";
    };
    systemPackages = with pkgs; [           # System-Wide Packages
      # Terminal
      bash
      tree
      htop              # Resource Manager
      coreutils         # GNU Utilities
      git               # Version Control
      killall           # Process Killer
      nano              # Text Editor
      vim
      nix-tree          # Browse Nix Store
      pciutils          # Manage PCI
      ranger            # File Manager
      tldr              # Helper
      usbutils          # Manage USB
      wget              # Retriever
      curl
      efibootmgr
      # Video/Audio
      # alsa-utils        # Audio Control
      # feh               # Image Viewer
      # mpv               # Media Player
      # pavucontrol       # Audio Control
      # pipewire          # Audio Server/Control
      # pulseaudio        # Audio Server/Control
      # vlc               # Media Player
      # stremio           # Media Streamer

      # Apps
      # appimage-run      # Runs AppImages on NixOS
      # google-chrome     # Browser
      # remmina           # XRDP & VNC Client

      # File Management
      # gnome.file-roller # Archive Manager
      # okular            # PDF Viewer
      # pcmanfm           # File Browser
      # p7zip             # Zip Encryption
      # rsync             # Syncer - $ rsync -r dir1/ dir2/
      # unzip             # Zip Files
      # unrar             # Rar Files
      # zip               # Zip

      # Other Packages Found @
      (pkgs.callPackage ./package.nix {}) #thorium browser self compiled
      e2fsprogs
    ] ++
    (with pkgs-unstable; [
      # firefox           # Browser
    ]);
    # ]) ++ ([ pkgs.firefox ]);  ## syntax for adding one without pkgs appended
  };
  hardware.pulseaudio.enable = false;
  services = {
    printing = {                            # CUPS
      enable = true;
    };
    pipewire = {                            # Sound
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
    };
    openssh = {                             # SSH
      enable = true;
      allowSFTP = true;                     # SFTP
      extraConfig = ''
        HostKeyAlgorithms +ssh-rsa
      '';
    };
  };
  system = {                                # NixOS Settings
    #autoUpgrade = {                        # Allow Auto Update (not useful in flakes)
    #  enable = true;
    #  channel = "https://nixos.org/channels/nixos-unstable";
    #};
    stateVersion = "${vars.stateVersion}";
  };

  home-manager.users.${vars.user} = {       # Home-Manager Settings
    home.stateVersion = "${vars.stateVersion}";
    programs.home-manager.enable = true;
  };
  nix = {
    settings.auto-optimise-store = true;
    gc = {                                  # Garbage Collection
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };
}

