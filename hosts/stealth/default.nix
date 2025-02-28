{ config, lib, system, inputs, host, pkgs, pkgs-unstable, ... }:  # TODO remove system, only when from all modules it is removed
# let
#   pkgs = import inputs.nixpkgs-unstable {
#     system = host.system;
#     config.allowUnfree = true;
#   };
#   pkgs-unstable = import inputs.nixpkgs-unstable {
#     system = host.system;
#     config.allowUnfree = true;
#   };
# in
{
  imports = [
    # inputs.nix-flatpak.nixosModules.nix-flatpak
    inputs.home-manager.nixosModules.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
    }
    inputs.nixos-cosmic.nixosModules.default
    inputs.disko.nixosModules.disko
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-gpu-intel-kaby-lake
    ./disk-config.nix
    ./hardware-configuration.nix
    {_module.args.disks = [ "/dev/nvme0n1" ];}
  ];
  boot.loader = {
    #systemd-boot.enable = true;
    grub.efiSupport = true; 
    grub.enable = true;
    grub.device = "nodev";
    #efi.efiSysMountPoint = "/boot/EFI";
    efi.canTouchEfiVariables = true;
  };
  networking.hostName = host.hostName; # Define your hostname.
  networking.networkmanager.enable = true;
  networking.firewall.enable = lib.mkForce false;

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };
  users.users.root.initialPassword = "nixos";
  users.defaultUserShell = pkgs.zsh;
  users.users.${host.vars.user} = {
    isNormalUser = true;
    description = "${host.vars.user}";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [];
    openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEGiVyNsVCk2KAGfCGosJUFig6PyCUwCaEp08p/0IDI7"];
  };
  environment.sessionVariables = {
    flake_name=host.hostName;
    FLAKE="$HOME/.flake";
    NIXOS_CONFIG="$HOME/.flake";
    # NIXOS_CONFIG="/home/${host.vars.user}/.flake";
    QT_STYLE_OVERRIDE="kvantum";
    NIXOS_OZONE_WL = "1";
  };
  #### modules
  gnome.enable = true;
  cosmic-desktop.enable = false;
  virtualization.enable = true;
  devops.enable = true;
  steam.enable = true;
  thorium.enable = true;
  rar.enable = true;
  wg-home.enable = true;
  storagefs.share.vega_nfs = true;
  flatpak.enable = true;
  # storagefs.share.vega_smb = true;
  ide.vscode = true;
  ####
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    alacritty
    kdePackages.dolphin
    kdePackages.ark
    kdePackages.breeze-icons
    kdePackages.breeze-gtk
    kdePackages.xdg-desktop-portal-kde
    kdePackages.kde-gtk-config
    kdePackages.kate
    gnumake
    haruna
    jq
    openssl
    distrobox
    qjournalctl
    xorg.xkill
  ] ++
    (with pkgs-unstable; [
      zsh
      btop
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
  

  fonts = { ## TODO entire block untested if even used, would like to use the Hack font
    fontDir.enable = true;
    fontconfig.enable = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      nerd-fonts.hack
      # (nerdfonts.override { fonts = [ "Hack" ]; })
    ];
    fontconfig = {
      defaultFonts = {
        serif = [  "Liberation Serif" "Vazirmatn" ];
        sansSerif = [ "Ubuntu" "Vazirmatn" ];
        monospace = [ "Ubuntu Mono" ];
      };
    };
  };

  home-manager.users.${host.vars.user} = {
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

  services.hardware.bolt.enable = true;

  hardware.bluetooth.enable = true;
  # services.udev.extraRules = ''
  #   # Finalmouse ULX devices
  #   # This file should be installed to /etc/udev/rules.d so that you can access the Finalmouse ULX devices without being root.
  #   #
  #   # type this at the command prompt: sudo cp 99-finalmouse.rules /etc/udev/rules.d

  #   SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="361d", ATTR{idProduct}=="0100", MODE="0666"
  #   SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="361d", ATTR{idProduct}=="0101", MODE="0666"
  #   SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="361d", ATTR{idProduct}=="0102", MODE="0666"
  #   SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="361d", ATTR{idProduct}=="0103", MODE="0666"
  #   SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="361d", ATTR{idProduct}=="0111", MODE="0666"

  #   KERNEL=="hidraw*", ATTRS{idVendor}=="361d", ATTRS{idProduct}=="0100", MODE="0666"
  #   KERNEL=="hidraw*", ATTRS{idVendor}=="361d", ATTRS{idProduct}=="0101", MODE="0666"
  #   KERNEL=="hidraw*", ATTRS{idVendor}=="361d", ATTRS{idProduct}=="0102", MODE="0666"
  # '';

  # programs.ssh.extraConfig = ''
  #   Host nixbuilder_dockeropen
  #     HostName builder1.nix.local.icylair.com
  #     Port 22
  #     User nixbuilder
  #     IdentitiesOnly yes
  #     StrictHostKeyChecking no
  #     IdentityFile ~/.ssh/id_local
  # '';
}
