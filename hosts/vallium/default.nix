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
    ./pika-backup.nix
    ./specialisation.nix
    ./pcie-passtrough.nix
    # ./winapps.nix
    # ./lvm.nix
    # inputs.nixos-facter-modules.nixosModules.facter{ config.facter.reportPath = ./facter.json; }
    # ./network-shares.nix
  ];
  fonts = { ## TODO entire block untested if even used, would like to use the Hack font
    fontDir.enable = true;
    fontconfig.enable = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
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
  # services.gnome.core-apps.enable = true; # TODO why was this defined globally?
  #services.getty.autologinUser = "user";
  # boot.kernelPackages = pkgs-unstable.linuxKernel.packages.linux_6_11;
  # boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.kernelPackages = pkgs-unstable.linuxPackages_latest;
  boot.kernelPackages = pkgs-master.linuxPackages_latest;
  # boot.kernelPackages = pkgs-master.linuxPackages_testing; # this installs linux release candidate #untested, does not compule cus nvidia

  # boot.consoleLogLevel  description of package -> The kernel console `loglevel`. All Kernel Messages with a log level smaller than this setting will be printed to the console.  https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/system/boot/kernel.nix
  boot.loader = {
    #systemd-boot.enable = true;
    timeout = 1;
    efi.canTouchEfiVariables = true;
    #efi.efiSysMountPoint = "/boot/EFI";
    # grub = {
    #   enable = true;
    #   efiSupport = true;
    #   device = "nodev"; # default
    #   # useOSProber = true;
    #   extraEntries = ''
    #       menuentry 'Windows Boot Manager' --class windows --class os $menuentry_id_option 'osprober-efi-8CCC-5043' {
    #         savedefault
    #         insmod part_gpt
    #         insmod fat
    #         search --no-floppy --fs-uuid --set=root 8CCC-5043
    #         chainloader /EFI/Microsoft/Boot/bootmgfw.efi
    #       }
    #   '';
    # };
    limine = {
      enable = true;
      enableEditor = true;
      efiSupport = true;
      # biosDevice = "nodev"; # default
      secureBoot.enable = true;
      extraEntries = ''
        /Windows
            protocol: efi
            path: uuid(eafba258-d1ca-4c97-821d-9effdf1756d2):/EFI/Microsoft/Boot/bootmgfw.efi
      '';
    };
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
  podman.enable = true;
  builder.builder1.remote = false;
  ide.vscode = true;
  ide.zed = true;
  flatpak.enable = true;

  device.woothing = true;
  device.finalmouse = true;
  device.orbital-pathfinder = true;

  storagefs.share.vega_nfs = true;

  ####
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = [
    # pkgs-master.pciutils # pciutils
    pkgs-unstable.pciutils # pciutils
    # pkgs-unstable.element-desktop
    # pkgs-unstable.coolercontrol.coolercontrol-gui
    # pkgs-unstable.coolercontrol.coolercontrold
    (pkgs-unstable.bottles.override {removeWarningPopup = true;}) #TODO investigate how this is done on the source and document, 14.06.2025 nixos-unstable

    # pkgs-master.lact
    ] ++ (with pkgs; [
    # songrec gsettings-desktop-schemas gsettings-qt
    # lact2
    #
    lm_sensors
    openlinkhub

    sbctl
    mokutil

    alacritty

    kdePackages.okular            # PDF Viewer

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
    # teamspeak3
    python3
    egl-wayland
    ((vim-full.override { }).customize {
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
  programs.zsh.enable = true; # TODO REMOVE ME, temp
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
    users.${host.vars.user} =  lib.mkMerge [
      (import ./home.nix)
      (import ../../modules/home-manager/mutability.nix)
      (import ./home-mutable.nix)
    ];
  };

  hardware.bluetooth = {
    enable = lib.mkForce true;
    powerOnBoot = lib.mkForce true;
    settings = {
      General = {
        # Shows battery charge of connected devices on supported
        # Bluetooth adapters. Defaults to 'false'.
        Experimental = true;
        # When enabled other devices can connect faster to us, however
        # the tradeoff is increased power consumption. Defaults to
        # 'false'.
        FastConnectable = true;
      };
      Policy = {
        # Enable all controllers when they are found. This includes
        # adapters present on start as well as adapters that are plugged
        # in later on. Defaults to 'true'.
        AutoEnable = true;
      };
    };
  };
  # services.fwupd.enable = true; # firmware upgrade tool
  environment.variables = {
    LD_LIBRARY_PATH=lib.mkForce "$NIX_LD_LIBRARY_PATH"; ## may break stuff
  };
  programs.nix-ld = {
    enable = true;
    # libraries = with pkgs; [
    #   alsa-lib
    #   at-spi2-atk
    #   at-spi2-core
    #   atk
    #   cairo
    #   cups
    #   curl
    #   dbus
    #   expat
    #   fontconfig
    #   freetype
    #   fuse3
    #   gdk-pixbuf
    #   glib
    #   gtk3
    #   icu
    #   libGL
    #   libappindicator-gtk3
    #   libdrm
    #   libglvnd
    #   libnotify
    #   libpulseaudio
    #   libunwind
    #   libusb1
    #   libuuid
    #   libxkbcommon
    #   libxml2
    #   mesa
    #   nspr
    #   nss
    #   openssl
    #   pango
    #   pipewire
    #   stdenv.cc.cc
    #   systemd
    #   vulkan-loader
    #   xorg.libX11
    #   xorg.libXScrnSaver
    #   xorg.libXcomposite
    #   xorg.libXcursor
    #   xorg.libXdamage
    #   xorg.libXext
    #   xorg.libXfixes
    #   xorg.libXi
    #   xorg.libXrandr
    #   xorg.libXrender
    #   xorg.libXtst
    #   xorg.libxcb
    #   xorg.libxkbfile
    #   xorg.libxshmfence
    #   zlib
    #   # add any missing dynamic libraries for unpacked programs here, not in the environment.systemPackages
    # ];
  };
  # programs.coolercontrol.enable = true;
  services.lact.enable = true;

  hardware.enableRedistributableFirmware = true;
  nixpkgs.config.permittedInsecurePackages = [
  "qtwebengine-5.15.19"
  ];# TODO REMOVE ME
  #
  # boot.extraModprobeConfig = ''
  #   # Replace 10de:1234 with your actual vendor:product ID
  #   options vfio-pci ids=144d:a804
  # '';

  # boot.kernelParams = [
  #   "amd_iommu=on"
  #   "iommu=pt"
  #   "vfio-pci.ids=144d:a804"
  # ];
  # boot.kernelModules = [ "vfio" "vfio_iommu_type1" "vfio_pci" ];


  # programs.obs-studio = {
  #   enable = true;

  #   # optional Nvidia hardware acceleration
  #   package = (
  #     pkgs.obs-studio.override {
  #       cudaSupport = true;
  #     }
  #   );

  #   plugins = with pkgs.obs-studio-plugins; [
  #     wlrobs
  #     obs-backgroundremoval
  #     obs-pipewire-audio-capture
  #     obs-vaapi #optional AMD hardware acceleration
  #     obs-gstreamer
  #     obs-vkcapture
  #   ];
  # };
}
