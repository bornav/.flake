{
  config,
  lib,
  inputs,
  host,
  pkgs,
  pkgs-stable,
  pkgs-unstable,
  pkgs-master,
  pkgs-local,
  pkgs-custom,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
    }
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    # inputs.nix-flatpak.nixosModules.nix-flatpak
    ./gpu.nix
    ./hardware-configuration.nix
    ./pika-backup.nix
    # ./specialisation.nix
    ./pcie-passtrough.nix
    ./my_modules.nix
    ./ai.nix

    ./alloy.nix

    # ./snapmaker-orca.nix

    # ./winapps.nix
    # ./lvm.nix
    # inputs.nixos-facter-modules.nixosModules.facter{ config.facter.reportPath = ./facter.json; }
    # ./network-shares.nix
    # ../../../modules/custom_pkg/librepods.nix
    inputs.snapmaker-orca.nixosModules.default
    {
      programs.snapmaker-orca.enable = true;
    }
  ];
  fonts = {
    ## TODO entire block untested if even used, would like to use the Hack font
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
        serif = ["Liberation Serif" "Vazirmatn"];
        sansSerif = ["Ubuntu" "Vazirmatn"];
        monospace = ["Ubuntu Mono"];
      };
    };
  };
  # services.gnome.core-apps.enable = true; # TODO why was this defined globally?
  #services.getty.autologinUser = "user";
  # boot.kernelPackages = pkgs-unstable.linuxKernel.packages.linux_6_18;
  # boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelPackages = pkgs-unstable.linuxPackages_latest;
  # boot.kernelPackages = lib.mkForce pkgs-master.linuxPackages_testing; # this installs linux release candidate #untested, does not compule cus nvidia
  # boot.kernelPackages = pkgs-master.linuxPackagesFor (pkgs-master.linux_latest.override {
  #     argsOverride = rec {
  #       # version = "6.19.0-rc1";
  #       version = "6.18.1"; #https://github.com/NixOS/nixpkgs/blob/master/pkgs/os-specific/linux/kernel/kernels-org.json
  #       modDirVersion = version;
  #       src = pkgs-master.fetchurl {
  #         # url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
  #         url = "https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.18.1.tar.xz";
  #         sha256 = "sha256-0KeL8/DRKqoQrzta3K7VvHZ7W3hwXl74hdXpMLcuJdU=";
  #       };

  #       # Optional: ignore missing modules directories warning
  #       ignoreConfigErrors = true;
  #     };
  #   });

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
      enableEditor = false;
      efiSupport = true;
      # biosDevice = "nodev"; # default
      secureBoot.enable = true;
      maxGenerations = 10;
      extraEntries = ''
        /Windows
            protocol: efi_chainload
            path: uuid(eafba258-d1ca-4c97-821d-9effdf1756d2):/EFI/Microsoft/Boot/bootmgfw.efi
        /catchyos
            protocol: linux
            module_path: boot():/03a70d31514c48d6adab5699aa5b96d8/linux-cachyos/initramfs-linux-cachyos#9dd8bfde87941367ec61938bf788f679566ca823d7ea7694319ad927e6e1842eee336f4df099b32a25246b7766fd61eedf0e183ad8fcbde323c1bd23c74e245c
            path: boot():/03a70d31514c48d6adab5699aa5b96d8/linux-cachyos/vmlinuz-linux-cachyos#14d26f1ce466a5c6bc1b1014fe971dd87d910517ed982fcfeb883f135e7cb599ab41d258f79143c2a6e5f0378bfe2e11cd77b9de60ac69d06957732f94bdc71c
            cmdline: quiet nowatchdog splash rw root=UUID=95ad0cf4-4e45-47b0-8d5e-5cb54f61befc
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
    extraGroups = ["networkmanager" "wheel" "docker" "wireshark" "i2c"];
    packages = with pkgs; [];
    openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEGiVyNsVCk2KAGfCGosJUFig6PyCUwCaEp08p/0IDI7"];
  };

  environment.sessionVariables = {
    flake_name = host.hostName;
    FLAKE = "$HOME/.flake";
    NIXOS_CONFIG = "$HOME/.flake";
    # NIXOS_CONFIG="/home/${host.vars.user}/.flake";
    # QT_STYLE_OVERRIDE="kvantum";
    WLR_NO_HARDWARE_CURSORS = "1"; # look into removing
    NIXOS_OZONE_WL = "1"; #Hint electron apps to use wayland
  };

  ####
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages =
    [
      pkgs-local.openshell
      # pkgs-custom.nano
      # pkgs-local.beyla
      # (pkgs-unstable.callPackage ../../modules/custom_pkg/temp.nix {})
      pkgs.scx.full
      (pkgs-unstable.callPackage ../../modules/custom_pkg/pince/package.nix {})
      (pkgs-unstable.callPackage ../../modules/custom_pkg/helium_browser.nix {})

      # (pkgs.callPackage ./snapmaker-orca.nix {inherit (pkgs) orca-slicer;})

      # pkgs-master.pciutils # pciutils
      pkgs-unstable.pciutils # pciutils
      pkgs-stable.element-desktop
      # pkgs-unstable.coolercontrol.coolercontrol-gui
      # pkgs-unstable.coolercontrol.coolercontrold

      # pkgs-master.lact
    ]
    ++ (with pkgs; [
      # songrec gsettings-desktop-schemas gsettings-qt
      # lact2
      #
      xkill
      xeyes

      vulkan-tools # both provide cli utilities to debug opengl/vulkan
      virtualglLib #

      freecad

      lm_sensors
      openlinkhub
      sbctl
      mokutil
      alacritty
      kdePackages.okular # PDF Viewer
      haruna
      jq
      kdiskmark
      # appimage-run # Runs AppImages on NixOS
      (pkgs.appimage-run.override {
        extraPkgs = pkgs: [pkgs.webkitgtk_4_1];
      })
      distrobox
      qjournalctl
      # remmina          # XRDP & VNC Client
      # sublime-merge
      feh
      gparted
      nordic
      papirus-nord
      # pciutils # lspci

      gvfs
      libglibutil
      fuse
      borgbackup
      btop
      nix-index
      ripgrep
      teamspeak6-client

      librepods

      nmap
      winboat

      firecracker

      handbrake

      # betterbird
      # teamspeak3
      python3
      egl-wayland
      ((vim-full.override {}).customize {
        name = "vim";
        vimrcConfig.customRC = ''
          set mouse=""
          set backspace=indent,eol,start
          syntax on
        '';
      })
    ])
    ++ (with pkgs-stable; [
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

  # # tailscale up --login-server <headscale.<domain>>  https://carlosvaz.com/posts/setting-up-headscale-on-nixos/
  # # headscale --namespace <namespace_name> nodes register --key <machine_key>
  # services.tailscale.enable = true;
  # networking.firewall = {
  #   checkReversePath = "loose";
  #   trustedInterfaces = [ "tailscale0" ];
  #   allowedUDPPorts = [ config.services.tailscale.port ];
  # };

  systemd.network.wait-online.enable = false;
  boot.initrd.systemd.network.wait-online.enable = false;
  ## for setting the default apps
  ## definition https://nix-community.github.io/home-manager/options.xhtml#opt-xdg.mimeApps.defaultApplications
  home-manager = {
    backupFileExtension = "backup";
    extraSpecialArgs = {inherit inputs;};
    users.${host.vars.user} = lib.mkMerge [
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
    LD_LIBRARY_PATH = lib.mkForce "$NIX_LD_LIBRARY_PATH"; ## may break stuff
    # PIPEWIRE_LATENCY = "32/48000"; # TODO test
  };
  programs.nix-ld = {
    enable = true;
  };

  # programs.coolercontrol.enable = true;
  services.lact.enable = true;

  hardware.enableRedistributableFirmware = true;
  nixpkgs.config.permittedInsecurePackages = [
    #"qtwebengine-5.15.19"
    #"libsoup-2.74.3"
  ]; # TODO REMOVE ME
  #
  # boot.extraModprobeConfig = ''
  #   # Replace 10de:1234 with your actual vendor:product ID
  #   options vfio-pci ids=144d:a804
  # '';

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

  #
  #  scheduler test
  # services.scx.enable = true;
  # services.scx.scheduler = "scx_rustland";

  services.netbird.enable = true;
  # services.netbird.package = pkgs-master.netbird;
  services.netbird.ui.enable = true;

  programs.hyprland.enable = true;
}
