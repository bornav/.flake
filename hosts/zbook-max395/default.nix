{ config, lib, system, inputs, host, pkgs, pkgs-unstable, pkgs-master, ... }:  # TODO remove system, only when from all modules it is removed
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
    # inputs.nixos-hardware.nixosModules.common-cpu-intel
    # inputs.nixos-hardware.nixosModules.common-gpu-intel-kaby-lake
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
  networking.networkmanager.enable = lib.mkForce true;
  networking.firewall.enable = lib.mkForce false;
  # networking.firewall.checkReversePath = false; 
  # networking.firewall.checkReversePath = "loose"; 

  # networking.networkmanager.dns = "none";
  networking.useDHCP = lib.mkForce false;
  networking.dhcpcd.enable = lib.mkForce false;

  boot.kernelPackages = lib.mkDefault pkgs-master.linuxPackages_latest;

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
    # QT_STYLE_OVERRIDE="kvantum";
    NIXOS_OZONE_WL = "1";
  };


  # services.tlp.enable = lib.mkForce false;
  # services.power-profiles-daemon.enable = lib.mkForce false;


  services.acpid.enable = true;

  # specialisation = {
  #   # k1.configuration = {boot.kernelPackages = lib.mkForce pkgs-unstable.linuxKernel.packages.linux_6_11;};
  #   k2.configuration = {boot.kernelPackages = lib.mkForce pkgs-unstable.linuxKernel.packages.linux_5_4;};
  #   k3.configuration = {boot.kernelPackages = lib.mkForce pkgs-unstable.linuxKernel.packages.linux_6_6;};
  #   # k4.configuration = {boot.kernelPackages = lib.mkForce pkgs-unstable.linuxKernel.packages.linux_6_11;};

  # };
  
  # specialisation = {
  # #  gnome.configuration = {
  # #    gnome.enable = lib.mkForce true;
  # #    cosmic-desktop.enable =  lib.mkForce false;
  # #    plasma.enable = lib.mkForce false;
  # #    hyprland.enable = lib.mkForce false;
  # #  };
  # #  hyprland.configuration = {
  # #    cosmic-desktop.enable = lib.mkForce false;
  # #    gnome.enable = lib.mkForce false;
  # #    plasma.enable = lib.mkForce false;
  # #    hyprland.enable = lib.mkForce true;
  # #  };
  # #  cosmic.configuration = {
  # #    cosmic-desktop.enable = lib.mkForce true;
  # #    gnome.enable = lib.mkForce false;
  # #    plasma.enable = lib.mkForce false;
  # #    hyprland.enable = lib.mkForce false;
  # #  };
  #  plasma.configuration = {
  #    cosmic-desktop.enable = lib.mkForce false;
  #    gnome.enable = lib.mkForce false;
  #    plasma.enable = lib.mkForce true;
  #    hyprland.enable = lib.mkForce false;
  #  };
  # };
  #### modules
  gnome.enable = lib.mkDefault false;
  plasma.enable = lib.mkDefault true;
  cosmic-desktop.enable = lib.mkDefault false;
  virtualization.enable = true;
  devops.enable = true;
  steam.enable = true;
  thorium.enable = true;
  rar.enable = true;
  wg-home.enable = true;
  wg-home.local_ip = "10.10.1.3/32";
  wg-home.privateKeyFileLocation = "/home/bocmo/.ssh/wg/zbook/priv.key";
  # flatpak.enable = true;
  # storagefs.share.vega_nfs = true;
  # storagefs.share.vega_smb = true;
  ide.vscode = true;
  docker.enable = true;
  ####
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = [
    pkgs-unstable.element-desktop
    ] ++ (with pkgs; [
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


    vulkan-tools
  ]) ++
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

  hardware.bluetooth.enable = lib.mkForce true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = lib.mkForce true;
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
  services.tailscale.enable = true;
  networking.firewall = {
    checkReversePath = "loose";
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];
  };
  # tailscale up --login-server <headscale.<domain>>  https://carlosvaz.com/posts/setting-up-headscale-on-nixos/
  # headscale --namespace <namespace_name> nodes register --key <machine_key>
  
  # systemd.network.enable = true;
  # services.resolved.dnssec = "allow-downgrade";
  # networking.useNetworkd = lib.mkDefault true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  services.lact.enable = true;
}
