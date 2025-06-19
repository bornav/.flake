{ config, lib, inputs, host, pkgs, pkgs-stable, pkgs-unstable, pkgs-master, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
    }
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.nixos-cosmic.nixosModules.default
    # inputs.nix-flatpak.nixosModules.nix-flatpak
    ./gpu.nix
    ./hardware-configuration.nix
    # inputs.nixos-facter-modules.nixosModules.facter{ config.facter.reportPath = ./facter.json; }
    # ./network-shares.nix
  ];
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
  services.gnome.core-utilities.enable = true;
  #services.getty.autologinUser = "bocmo";
  # boot.kernelPackages = pkgs-unstable.linuxKernel.packages.linux_6_11;
  # boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelPackages = pkgs-master.linuxPackages_latest;
  # boot.kernelPackages = pkgs-master.linuxPackages_testing; # this installs linux release candidate #untested, does not compule cus nvidia

  # boot.consoleLogLevel  description of package -> The kernel console `loglevel`. All Kernel Messages with a log level smaller than this setting will be printed to the console.  https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/system/boot/kernel.nix
  boot.loader = {
    #systemd-boot.enable = true;
    timeout = 1;
    grub.efiSupport = true; 
    grub.enable = true;
    grub.device = "nodev";
    #efi.efiSysMountPoint = "/boot/EFI";
    efi.canTouchEfiVariables = true;
    # grub.useOSProber = true;
    grub.extraEntries = ''
        menuentry 'Windows Boot Manager (on /dev/nvme1n1p3)' --class windows --class os $menuentry_id_option 'osprober-efi-D050-C7EF' {
          savedefault
          insmod part_gpt
          insmod fat
          search --no-floppy --fs-uuid --set=root D050-C7EF
          chainloader /EFI/Microsoft/Boot/bootmgfw.efi
        }
    '';
        # menuentry 'Arch Linux, with Linux linux' --class arch --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-linux-advanced-109c9c71-abfc-46d9-b983-9dd681b53ce4' {
        #   savedefault
        #   set gfxpayload=keep
        #   insmod gzio
        #   insmod part_gpt
        #   insmod fat
        #   search --no-floppy --label BOOT
        #   echo    'Loading Linux linux ...'
        #   linux   /vmlinuz-linux root=LABEL=root_partition rw  loglevel=3 nvidia-drm.modeset=1 iommu=pt
        #   echo    'Loading initial ramdisk ...'
        #   initrd  /amd-ucode.img /initramfs-linux.img
        # }
  };
  networking.hostName = host.hostName; # Define your hostname.
  networking.networkmanager.enable = true;
  networking.firewall.enable = lib.mkForce false;

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };
  users.defaultUserShell = pkgs.zsh;
  users.users.${host.vars.user} = {
    initialPassword = "nixos";
    isNormalUser = true;
    description = "${host.vars.user}";
    extraGroups = [ "networkmanager" "wheel" "docker" "wireshark" ];
    packages = with pkgs; [];
    openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEGiVyNsVCk2KAGfCGosJUFig6PyCUwCaEp08p/0IDI7"];
  };

  environment.sessionVariables = {
    flake_name=host.hostName;
    FLAKE="$HOME/.flake";
    NIXOS_CONFIG="$HOME/.flake";
    # NIXOS_CONFIG="/home/${host.vars.user}/.flake";
    # QT_STYLE_OVERRIDE="kvantum";
    WLR_NO_HARDWARE_CURSORS = "1"; # look into removing
    NIXOS_OZONE_WL = "1"; #Hint electron apps to use wayland
  };
  # #### modules
  specialisation = {
   gnome.configuration = {
     gnome.enable = lib.mkForce true;
     cosmic-desktop.enable =  lib.mkForce false;
     plasma.enable = lib.mkForce false;
     hyprland.enable = lib.mkForce false;
   };
  #  hyprland.configuration = {
  #    cosmic-desktop.enable = lib.mkForce false;
  #    gnome.enable = lib.mkForce false;
  #    plasma.enable = lib.mkForce false;
  #    hyprland.enable = lib.mkForce true;
  #  };
  #  cosmic.configuration = {
  #    cosmic-desktop.enable = lib.mkForce true;
  #    gnome.enable = lib.mkForce false;
  #    plasma.enable = lib.mkForce false;
  #    hyprland.enable = lib.mkForce false;
  #  };
  #  plasma.configuration = {
  #    cosmic-desktop.enable = lib.mkForce false;
  #    gnome.enable = lib.mkForce false;
  #    plasma.enable = lib.mkForce true;
  #    hyprland.enable = lib.mkForce false;
  #  };
  };
  # gnome.enable = lib.mkDefault true;
  plasma.enable = lib.mkDefault true;
  # hyprland.enable = lib.mkForce false;
  cosmic-desktop.enable = lib.mkDefault false;
  virtualization.enable = true;
  virtualization.qemu = true;
  # virtualization.waydroid = true;
  devops.enable = true;
  steam.enable = true;
  emulation.switch = true;
  games.applications.enable = true;
  rar.enable = true;
  thorium.enable = true;
  wg-home.enable = false;
  ai.enable = true;
  docker.enable = true;
  builder.builder1.remote = false;
  ide.vscode = true;
  ide.zed = true;
  flatpak.enable = true;

  device.woothing = true;
  device.finalmouse = true;

  storagefs.share.vega_nfs = true;

  ####
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = [
    # pkgs-master.pciutils # pciutils 
    pkgs-unstable.pciutils # pciutils 
    # pkgs-unstable.coolercontrol.coolercontrol-gui
    # pkgs-unstable.coolercontrol.coolercontrold
    (pkgs-unstable.bottles.override {removeWarningPopup = true;}) #TODO investigate how this is done on the source and document, 14.06.2025 nixos-unstable
    
    # pkgs-master.lact
    ] ++ (with pkgs; [
    # songrec gsettings-desktop-schemas gsettings-qt
    # lact2

    alacritty
    # libsForQt5.qtstyleplugin-kvantum
    # libsForQt5.qtstyleplugins
    # libsForQt5.breeze-qt5
    kdePackages.dolphin
    kdePackages.ark
    kdePackages.breeze-icons
    kdePackages.breeze-gtk
    kdePackages.kde-gtk-config
    kdePackages.xdg-desktop-portal-kde
    kdePackages.okular            # PDF Viewer
    kdePackages.kate
    kdePackages.filelight
    kdePackages.kfind

    haruna
    jq
    kdiskmark
    appimage-run      # Runs AppImages on NixOS
    distrobox
    qjournalctl
    # remmina          # XRDP & VNC Client
    # sublime-merge
    feh
    gparted
    teamspeak_client
    nordic
    papirus-nord
    # pciutils # lspci
    pika-backup
    gvfs
    libglibutil
    fuse
    borgbackup
    btop
    nix-index
    ripgrep
    # betterbird
    python3
    egl-wayland
    ((vim_configurable.override { }).customize {
    name = "vim";
      vimrcConfig.customRC = ''
        set mouse=""
        set backspace=indent,eol,start
        syntax on
      '';
    })
  ]) ++ (with pkgs-stable; [
      xorg.xkill
      xorg.xeyes
      wireshark
      # orca-slicer
      # openrgb
      avahi
  ]);
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = false;
  };
  
  services.tailscale.enable = true;
  networking.firewall = {
    checkReversePath = "loose";
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];
  };
  # tailscale up --login-server <headscale.<domain>>  https://carlosvaz.com/posts/setting-up-headscale-on-nixos/
  # headscale --namespace <namespace_name> nodes register --key <machine_key>
  
  systemd.network.wait-online.enable = false;
  boot.initrd.systemd.network.wait-online.enable = false;
  ## for setting the default apps
  ## definition https://nix-community.github.io/home-manager/options.xhtml#opt-xdg.mimeApps.defaultApplications
  home-manager = {
    backupFileExtension = "backup";
    extraSpecialArgs = {inherit inputs;};
    users.${host.vars.user} = import ./home.nix;
  };
  
  ##gargabe collection
  
  hardware.bluetooth.enable = lib.mkForce true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = lib.mkForce true;
  
  environment.variables = {
    LD_LIBRARY_PATH=lib.mkForce "$NIX_LD_LIBRARY_PATH"; ## may break stuff
  };
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      alsa-lib
      at-spi2-atk
      at-spi2-core
      atk
      cairo
      cups
      curl
      dbus
      expat
      fontconfig
      freetype
      fuse3
      gdk-pixbuf
      glib
      gtk3
      icu
      libGL
      libappindicator-gtk3
      libdrm
      libglvnd
      libnotify
      libpulseaudio
      libunwind
      libusb1
      libuuid
      libxkbcommon
      libxml2
      mesa
      nspr
      nss
      openssl
      pango
      pipewire
      stdenv.cc.cc
      systemd
      vulkan-loader
      xorg.libX11
      xorg.libXScrnSaver
      xorg.libXcomposite
      xorg.libXcursor
      xorg.libXdamage
      xorg.libXext
      xorg.libXfixes
      xorg.libXi
      xorg.libXrandr
      xorg.libXrender
      xorg.libXtst
      xorg.libxcb
      xorg.libxkbfile
      xorg.libxshmfence
      zlib
      # add any missing dynamic libraries for unpacked programs here, not in the environment.systemPackages
    ];
  };
  # programs.coolercontrol.enable = true;


  services.lact.enable = true;
}
