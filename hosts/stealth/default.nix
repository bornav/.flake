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
    xkb.layout = "us";
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
    FLAKE="$HOME/.flake";
    NIXOS_CONFIG="$HOME/.flake";
    # NIXOS_CONFIG="/home/${vars.user}/.flake";
    QT_STYLE_OVERRIDE="kvantum";
    NIXOS_OZONE_WL = "1";
  };

  #### modules
  gnome.enable = false;
  cosmic-desktop.enable = true;
  virtualization.enable = true;
  devops.enable = true;
  steam.enable = true;
  thorium.enable = true;
  virtualisation.docker.enable = true;
  rar.enable = true;
  wg-home.enable = false;
  ####
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
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
    ]);
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = false;
  };
  services.flatpak.enable = true;

    home-manager.users.${vars.user} = {
    xdg.mime.enable = true;
    xdg.mimeApps.enable = true;
    ## this may be neccesary sometimes
    # xdg.configFile."mimeapps.list".force = true;
    ## from limited testing it is only applied if both sides are valid
    xdg.mimeApps.defaultApplications."text/html" = "thorium-browser.desktop";
    xdg.mimeApps.defaultApplications = {
      "text/xml" = [ "thorium-browser.desktop" ];
      "x-scheme-handler/http" = [ "thorium-browser.desktop" ];
      "x-scheme-handler/https" = [ "thorium-browser.desktop" ];
      "inode/directory" = "org.kde.dolphin.desktop";
    };
  };

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
