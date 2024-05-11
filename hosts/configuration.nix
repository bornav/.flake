{inputs, config, pkgs, pkgs-unstable, vars, ... }:
{
  imports = ( import ../modules/shell ++
              import ../modules/terminalEmulators ++
              import ../modules/virtualization ++
              import ../modules/dev ++
              import ../modules/gaming ++
              import ../modules/common ++
              import ../modules/vpn ++
              import ../modules/custom_pkg ++
              import ../modules/devices ++
              import ../modules/nix ++
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
      fastfetch #neofetch
      gnumake
      openssl
      xdg-utils
      nh
      tmux
      # dbus
      # dbus-broker
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
  users.users.root.openssh.authorizedKeys.keys = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDeIvrOE9lMNjGuW6pm0RMGET8ze+Qr9/R4fgXplguadgOPi1rys3mRXkxMLMPgLbKrSRACt33arRprfnSbA6YIMl6WdaOSJAh0uPHeD82tt90F2DuQKCqCLmjbQenaFrjBlTlKnSpRTZd0m+5nfHOSE4XCyIllULhBKh6wrNdulJ3X7ZrpqS3gS/P5R7jxghScjUR/Y+GmhuLroow85LgzGQuoDfanm6YQgTB9Y+vYzUIZWs6edAEkGesTUJdnAxUIrEssBZUiWfw/ZqwK+APiQ0cCjcr8PR4wHMo0gK2Xgspn6FoIpogQBCJreQ2gColot9uYZaE6qla3JtAP3qlcjstkbh0qploijz0AMLLM8njs6hK5XSnjLsvc68q1OfS8NREWCs2z7m7ZR3UbeKcl1P3UkPsbCnqTFao618ISb2ButR5yFROqmKdk4fcQajdlKRtvgMc6zC0OI5ApyLCCIhPwGDrTjMl1rrAL7O1/aV8jg2X1Efqg1g1UV3qsmnSNUUO30W0EMI63KlynOF9uSpuBTc5we2OIK2hOF6ty5wpb3Y6a+vNnEl8A4QqvhTA0DZB4miH1PGweAc5P1mrNHcmj3oBGh3FxkxH8dpltkP5lckIHcRHZEKdLrQN0y54aoE9mfm08q3StmS0PDFI1LhUaH7wIxCApMLl+TYIFFw=="];
  system = {                                # NixOS Settings
    autoUpgrade = {                        # Allow Auto Update (not useful in flakes)
     enable = true;
     flake = inputs.self.outPath;
     flags = [
       "--update-input"
       "nixpkgs"
       "-L"
     ];
    };
    stateVersion = "${vars.stateVersion}";
  };
  systemd.extraConfig = ''
    DefaultTimeoutStopSec=5s
  ''; # sets the systemd stopjob timeout to somethng else than 90 seconds
  home-manager.users.${vars.user} = {       # Home-Manager Settings
    home.stateVersion = "${vars.stateVersion}";
    programs.home-manager.enable = true;
    xdg.enable= true;
    # xdg.desktopEntries = {
    #   thoooor = {
    #     name = "thoooor";
    #     genericName = "Web Browser";
    #     exec = "thorium ";
    #     terminal = false;
    #     categories = [ "Application" "Network" "WebBrowser" ];
    #     mimeType = [ "text/html" "text/xml" ];
    #   };
    # };
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
    settings.max-jobs = 4;
  };
}
