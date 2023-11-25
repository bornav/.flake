{ config, pkgs, vars, ... }:

{
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
      # - ./<host>/default.nix
      # - ../modules
    ];
    # ] ++
    # (with unstable; [
    #   # Apps
    #   # firefox           # Browser
    # ]);
  };

  system.stateVersion = "23.11";# Did you read the comment?
  nix = {
	package = pkgs.nixFlakes;
	extraOptions = "experimental-features = nix-command flakes";
  };
}

