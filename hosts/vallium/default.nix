{ config, pkgs, pkgs-unstable, vars, ... }:

{
  imports = [ 
    ./hardware-configuration.nix
    ./network-shares.nix
    ./vpn.nix
  ];

  # boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelPackages = pkgs-unstable.linuxKernel.packages.linux_6_8;
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
    flake_name="vallium";
    NIXOS_CONFIG="$HOME/.flake";
    # NIXOS_CONFIG="/home/${vars.user}/.flake";
    QT_STYLE_OVERRIDE="kvantum";
  };

  #### modules
  gnome.enable = true;
  # cosmic-desktop.enable = true;
  virtualization.enable = true;
  devops.enable = true;
  steam.enable = true;
  rar.enable = true;

  # services.desktopManager.cosmic.enable = true;
  # services.displayManager.cosmic-greeter.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    # extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
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
    okular            # PDF Viewer
    haruna
    kate
    jq
    kdiskmark
    appimage-run      # Runs AppImages on NixOS
    distrobox
    qjournalctl
    xorg.xkill
    remmina           # XRDP & VNC Client
    sublime-merge
    gparted
    teamspeak_client
    nordic
    papirus-nord
  ] ++
    (with pkgs-unstable; [
      vscode
      zsh
      linux
      # orca-slicer
      # openrgb
      (pkgs.callPackage ../thorium.nix {}) #thorium browser self compiled
      # (pkgs.callPackage https://github.com/NixOS/nixpkgs/blob/d48979f4e62d5e98a171f8c0ebf839997ea714f0/pkgs/tools/misc/ollama-webui/default.nix {})
      # (import ./package2.nix)    
      # zsh-completions
      # zsh-autocomplete
      # ollama
      # gpt4all
    ]);
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = false;
  };
  programs.zsh.enable = true;
  ## for setting the default apps
  ## definition https://nix-community.github.io/home-manager/options.xhtml#opt-xdg.mimeApps.defaultApplications
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

  virtualisation.docker.enable = true;

  services.flatpak.enable = true;
   
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

