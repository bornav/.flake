{ config, pkgs, pkgs-unstable, vars, ... }:

{
  imports = ( import ../modules/shell ++
              import ../modules/terminalEmulators ++
              import ../modules/virtualization ++
              import ../modules/dev ++
              import ../modules/gaming ++
              import ../modules/common ++
              import ../modules/vpn ++
              import ../modules/de);
  time.timeZone = "Europe/Vienna";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
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
  };
  environment = {
    variables = {
      TERMINAL = "${vars.terminal}";
      EDITOR = "${vars.editor}";
      VISUAL = "${vars.editor}";
    };
    systemPackages = with pkgs; [
      wget
      bash
      tree
      htop              # Resource Manager
      coreutils         # GNU Utilities
      git               # Version Control
      killall           # Process Killer
      nano              # Text Editor
      vim
      nix-tree          # Browse Nix Store
      tldr              # Helper
      usbutils          # Manage USB
      wget              # Retriever
      curl
      efibootmgr
      ntfs3g
      neofetch
      gnumake
      openssl
      xdg-utils
    ] ++
    (with pkgs-unstable; [
      
    ]);
    # ]) ++ ([ pkgs.firefox ]);  ## syntax for adding one without pkgs appended
  };
  hardware.pulseaudio.enable = false;
  services = {
    printing.enable = true;
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

