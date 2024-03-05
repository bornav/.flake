{ config, pkgs, pkgs-unstable, vars, ... }:

{
  imports = [ 
    ./hardware-configuration.nix
    ./network-shares.nix
    ./vpn.nix
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
        menuentry 'Windows Boot Manager (on /dev/nvme0n1p1)' --class windows --class os $menuentry_id_option 'windows' {
          savedefault
          insmod part_gpt
          insmod fat
          search --no-floppy --label BOOT
          chainloader /EFI/Microsoft/Boot/bootmgfw.efi
        }
        menuentry 'Arch Linux, with Linux linux' --class arch --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-linux-advanced-109c9c71-abfc-46d9-b983-9dd681b53ce4' {
          savedefault
          set gfxpayload=keep
          insmod gzio
          insmod part_gpt
          insmod fat
          search --no-floppy --label BOOT
          echo    'Loading Linux linux ...'
          linux   /vmlinuz-linux root=LABEL=root_partition rw  loglevel=3 nvidia-drm.modeset=1 iommu=pt
          echo    'Loading initial ramdisk ...'
          initrd  /amd-ucode.img /initramfs-linux.img
        }
    '';
  };
  networking.hostName = "vallium"; # Define your hostname.

  networking.networkmanager.enable = true;
 
  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };
  users.defaultUserShell = pkgs.zsh;
  users.users.${vars.user} = {
    isNormalUser = true;
    description = "${vars.user}";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [];
  };
  environment.sessionVariables = {
    flake_name="vallium";
    NIXOS_CONFIG="$HOME/.flake";
    # NIXOS_CONFIG="/home/${vars.user}/.flake";
    QT_STYLE_OVERRIDE="kvantum";
  };

  #modules
  gnome.enable = true;
  cosmic-desktop.enable = true;
  virtualization.enable = true;
  devops.enable = true;
  steam.enable = true;

  nixpkgs.config.allowUnfree = true;
  ###################################################
  #gnome part
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  #####################################################
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
    unrar
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
      orca-slicer
      openrgb
      # zsh-completions
      # zsh-autocomplete
      gpt4all
    ]);
 programs.gnupg.agent = {
   enable = true;
   enableSSHSupport = false;
 };

  virtualisation.docker.enable = true;

  services.flatpak.enable = true;


  # #steam
  # programs.steam = {
  #   enable = true;
  #   remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  #   dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  # };
  # hardware.opengl.driSupport32Bit = true; # Enables support for 32bit libs that steam uses
  ##
  
  ##
  ##gargabe collection
  programs.dconf.enable = true;

  #finalmouse udev rules for browser access
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

