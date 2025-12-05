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
    ./my_modules.nix
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

  ####
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = [
    (pkgs-unstable.callPackage ../../modules/custom_pkg/pince/package.nix {})
    (pkgs-unstable.callPackage ../../modules/custom_pkg/helium_browser.nix {})
    inputs.flox.packages.${pkgs.stdenv.hostPlatform.system}.default

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
      kdePackages.kmail
      kdePackages.kmailtransport
      kdePackages.kmail-account-wizard
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
    # PIPEWIRE_LATENCY = "32/48000"; # TODO test
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

  # nixpkgs.overlays = [
  #   (self: super: {
  #     kdePackages = super.kdePackages.overrideScope (kfinal: kprev: {
  #       kwin = kprev.kwin.overrideAttrs (oldAttrs: {
  #         src = self.fetchFromGitLab {
  #           domain = "invent.kde.org";
  #           owner = "plasma";
  #           repo = "kwin";
  #           rev = "2f3ae324ba430b2f4582473eefbe6db2e2a2a567";
  #           hash = "sha256-Hq6Ko3SRhfLjQ3wZXDzm89ktaFvc4qxmtOOObrR5nbs=";
  #         };
  #       });
  #     });
  #   })
  # ];

  # nixpkgs.overlays = [
  #   (self: super: {
  #     kdePackages = super.kdePackages.overrideScope (kfinal: kprev: {
  #       kwin = kprev.kwin.overrideAttrs (oldAttrs: {
  #         src = builtins.fetchGit {
  #           url = "https://invent.kde.org/plasma/kwin";
  #           rev = "2f3ae324ba430b2f4582473eefbe6db2e2a2a567";
  #         };
  #       });
  #     });
  #   })
  # ];
  #
  # nixpkgs.overlays = [
  #   (final: prev: {
  #     zed-editor = prev.zed-editor.overrideAttrs (oldAttrs: rec {
  #       version = "0.214.7";

  #       src = prev.fetchFromGitHub {
  #         owner = "zed-industries";
  #         repo = "zed";
  #         tag = "v${version}";
  #         hash = "sha256-DHKwGE5/FL3gYm9DwM1sGRsdX8kbhojLmi4B00Grtqg=";
  #       };

  #       cargoDeps = oldAttrs.cargoDeps.overrideAttrs (prev.lib.const {
  #         name = "zed-editor-${version}-vendor.tar.gz";
  #         inherit src;
  #         outputHash = "sha256-DHKwGE5/FL3gYm9DwM1sGRsdX8kbhojLmi4B00Grtqg=";
  #       });
  #     });
  #   })
  # ];
  # nixpkgs = {
  #   overlays = [
  #     (final: prev: {
  #       zed-editor = prev.zed-editor.overrideAttrs (oldAttrs: rec {
  #         version = "0.214.7";
  #         src = prev.fetchFromGitHub {
  #           owner = "zed-industries";
  #           repo = "zed";
  #           tag = "v${version}";
  #           hash = "sha256-DHKwGE5/FL3gYm9DwM1sGRsdX8kbhojLmi4B00Grtqg=";
  #         };
  #         cargoDeps = final.rustPlatform.fetchCargoVendor {
  #           inherit src;
  #           hash = "sha256-bq1iMDj6x57GQPo2OjGYduzdasor3A7QXnPqNEHQlKg=";
  #         };
  #         patches = (oldAttrs.patches or [ ]);
  #       });
  #     })
  #   ];
  # };
  #
  # nixpkgs.overlays = [
  #     (final: prev: {
  #       zed-editor = prev.zed-editor.overrideAttrs (oldAttrs: rec {
  #         version = "0.214.7";

  #         src = prev.fetchFromGitHub {
  #           owner = "zed-industries";
  #           repo = "zed";
  #           tag = "v${version}";
  #           hash = "sha256-DHKwGE5/FL3gYm9DwM1sGRsdX8kbhojLmi4B00Grtqg=";  # Get hash from build error
  #         };
  #         cargoDeps = oldAttrs.cargoDeps.overrideAttrs (previousAttrs: {
  #                 vendorStaging = previousAttrs.vendorStaging.overrideAttrs {
  #                   inherit (final) src;
  #                   # Deliberately invalid hash -- I'm not sure how to effectively
  #                   # pre-determine it.
  #                   outputHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  #                 };
  #               }
  #             );

  #         # cargoHash = "sha256-0374lbhzb7fm1mcw967p9z5slgr02kapc3s4l9i2mqb";  # Get hash from build error
  #         # cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
  #         #             inherit (final) src version;
  #         #             hash = "${cargoHash}";
  #         #           };
  #       });
  #     })
  #   ];
}
