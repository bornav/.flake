{ config, pkgs, pkgs-unstable, vars, ... }:

{
  imports = [ 
    ./hardware-configuration.nix
  ];
  boot.loader = {
    #systemd-boot.enable = true;
    grub.efiSupport = true;
    grub.enable = true;
    grub.device = "nodev";
    #efi.efiSysMountPoint = "/boot/EFI";
    efi.canTouchEfiVariables = true;
    #grub.useOSProber = true;
    grub.extraEntries = ''
    '';
  };
  networking.hostName = "stealth"; # Define your hostname.
  networking.networkmanager.enable = true;
 
  # Configure keymap in X11
  services.xserver = {
    # layout = "us";
    xkb.layout = "us";
    # xkbVariant = "";
    xkb.variant = "";
  };
  users.defaultUserShell = pkgs.zsh;
  users.users.${vars.user} = {
    isNormalUser = true;
    description = "${vars.user}";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [];
  };
  environment.sessionVariables = {
    flake_name="stealth";
    NIXOS_CONFIG="$HOME/.flake";
    # NIXOS_CONFIG="/home/${vars.user}/.flake";
    QT_STYLE_OVERRIDE="kvantum";
  };

  #### modules
  gnome.enable = true;
  cosmic-desktop.enable = false;
  virtualization.enable = false;
  devops.enable = true;
  steam.enable = false;
  rar.enable = true;
  ####

  nixpkgs.config.allowUnfree = true; 

  environment.systemPackages = with pkgs; [
    vim 
    alacritty
    libsForQt5.dolphin
    libsForQt5.qtstyleplugin-kvantum
    libsForQt5.qtstyleplugins
    libsForQt5.ark
    libsForQt5.breeze-icons
    libsForQt5.breeze-qt5
    libsForQt5.breeze-gtk
    libsForQt5.xdg-desktop-portal-kde
    libsForQt5.kde-gtk-config
    wget
    git
    neofetch
    gnumake
    haruna
    kate
    jq
    openssl
    distrobox
    qjournalctl
    xorg.xkill

  ] ++
    (with pkgs-unstable; [
      vscode
      zsh
      # orca-slicer
      # openrgb
      # zsh-completions
      # zsh-autocomplete
      # gpt4all-chat
      (pkgs.callPackage ../thorium.nix {}) #thorium browser self compiled
    ]);
 programs.gnupg.agent = {
   enable = true;
   enableSSHSupport = false;
 };

  services.flatpak.enable = true;

  ##
  ##gargabe collection
  programs.dconf.enable = true;

  services.udev.extraRules = ''
    # Finalmouse ULX devices
    # This file should be installed to /etc/udev/rules.d so that you can access the Finalmouse ULX devices without being root.
    #
    # type this at the command prompt: sudo cp 99-finalmouse.rules /etc/udev/rules.d

    SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="361d", ATTR{idProduct}=="0100", MODE="0666"
    SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="361d", ATTR{idProduct}=="0101", MODE="0666"
    SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="361d", ATTR{idProduct}=="0102", MODE="0666"
    SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="361d", ATTR{idProduct}=="0103", MODE="0666"
    SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="361d", ATTR{idProduct}=="0111", MODE="0666"

    KERNEL=="hidraw*", ATTRS{idVendor}=="361d", ATTRS{idProduct}=="0100", MODE="0666"
    KERNEL=="hidraw*", ATTRS{idVendor}=="361d", ATTRS{idProduct}=="0101", MODE="0666"
    KERNEL=="hidraw*", ATTRS{idVendor}=="361d", ATTRS{idProduct}=="0102", MODE="0666"
  '';
}

