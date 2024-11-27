{ config, lib, system, inputs, host, ... }:  # TODO remove system, only when from all modules it is removed
let
  pkgs = import inputs.nixpkgs-unstable {
    system = host.system;
    config.allowUnfree = true;
  };
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = host.system;
    config.allowUnfree = true;
  };
in
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
    inputs.nix-flatpak.nixosModules.nix-flatpak
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
      (nerdfonts.override { fonts = [ "Hack" ]; })
    ];
    fontconfig = {
      defaultFonts = {
        serif = [  "Liberation Serif" "Vazirmatn" ];
        sansSerif = [ "Ubuntu" "Vazirmatn" ];
        monospace = [ "Ubuntu Mono" ];
      };
    };
  };
  #services.getty.autologinUser = "bocmo";
  # boot.kernelPackages = pkgs-unstable.linuxPackages_latest;
  boot.kernelPackages = pkgs-unstable.linuxKernel.packages.linux_6_12;
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
   hyprland.configuration = {
     cosmic-desktop.enable = lib.mkForce false;
     gnome.enable = lib.mkForce false;
     plasma.enable = lib.mkForce false;
     hyprland.enable = lib.mkForce true;
   };
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
  cosmic-desktop.enable = lib.mkDefault false;
  virtualization.enable = true;
  virtualization.qemu = true;
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

  device.woothing = true;
  device.finalmouse = true;

  storagefs.share.vega_nfs = true;

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
    # libsForQt5.xdg-desktop-portal-kde
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
    # remmina          # XRDP & VNC Client
    # sublime-merge
    feh
    gparted
    teamspeak_client
    nordic
    papirus-nord
    pciutils # lspci
    pika-backup
    btop
    filelight
    nix-index
    kfind
    kitty
    # betterbird
    xorg.xeyes
    python3
    ((vim_configurable.override { }).customize {
    name = "vim";
      vimrcConfig.customRC = ''
        set mouse=""
        set backspace=indent,eol,start
        syntax on
      '';
    })
  ] ++
    (with pkgs-unstable; [
      wireshark
      # linux
      # orca-slicer
      # openrgb
      # zsh-completions
      # zsh-autocomplete
      avahi
      # ollama
      # lmstudio
      # gpt4all     
      egl-wayland

    ]);
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = false;
  };
  
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
  systemd.network.wait-online.enable = false;
  boot.initrd.systemd.network.wait-online.enable = false;
  ## for setting the default apps
  ## definition https://nix-community.github.io/home-manager/options.xhtml#opt-xdg.mimeApps.defaultApplications
  home-manager.users.${host.vars.user} = {
    xdg.mime.enable = true;
    xdg.mimeApps.enable = true;
    ## this may be neccesary sometimes
    # xdg.configFile."mimeapps.list".force = true;
    ## from limited testing it is only applied if both sides are valid
    xdg.mimeApps.defaultApplications = {
      "inode/directory" = "org.kde.dolphin.desktop";
    };
    home.file.".local/share/flatpak/overrides/global".text = ''
    [Context]
    filesystems=/run/current-system/sw/share/X11/fonts:ro;/nix/store:ro
    '';
  };
  
  services.flatpak.enable = true;
  services.flatpak.packages = [
      # { appId = "com.brave.Browser"; origin = "flathub";  }
      # "com.obsproject.Studio"
      # "im.riot.Riot"
      "com.github.tchx84.Flatseal"
      "app/org.kicad.KiCad/x86_64/stable"
      "it.mijorus.gearlever"
      "app/com.usebottles.bottles/x86_64/stable"
    ];
  services.flatpak.update.auto = {
    enable = true;
    onCalendar = "daily"; # Default value
  };
  ##
  ##gargabe collection
  
  services.udev.extraRules = ''
    ACTION=="add", KERNEL=="0000:00:03.0", SUBSYSTEM=="pci", RUN+="/bin/sh -c 'echo 1 > /sys/bus/pci/devices/0000:6c:00.0/remove'"
  '';

  #nvidia
  hardware.bluetooth.enable = true;
  hardware = {
    nvidia = {
      modesetting.enable = true;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
      # package = lib.mkForce config.boot.kernelPackages.nvidiaPackages.latest;
      # package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      #   version = "565.57.01";
      #   sha256_64bit = "sha256-buvpTlheOF6IBPWnQVLfQUiHv4GcwhvZW3Ks0PsYLHo=";
      #   sha256_aarch64 = lib.fakeSha256;
      #   openSha256 = lib.fakeSha256;
      #   settingsSha256 = "sha256-vWnrXlBCb3K5uVkDFmJDVq51wrCoqgPF03lSjZOuU8M=";
      #   persistencedSha256 = "sha256-hdszsACWNqkCh8G4VBNitDT85gk9gJe1BlQ8LdrYIkg=";
      # };

      # forceFullCompositionPipeline = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      # prime = {
      #   offload.enable = true;
      #   #sync.enable = true;
      #   amdgpuBusId = "PCI:108:0:0"; # lspci value, converted hex to decimal
      #   nvidiaBusId = "PCI:1:0:0";
      # };
      # prime = {
      #   # For people who want to use sync instead of offload. Especially for AMD CPU users
      #   sync.enable = lib.mkOverride 990 true;
      #   amdgpuBusId = "";
      #   nvidiaBusId = "";
      # };
    };
    graphics.enable = true;
    graphics.enable32Bit = true;
  };
  # environment.systemPackages = with pkgs-unstable; [ linuxKernel.packages.linux_6_8.nvidia_x11 ];
  services.xserver.videoDrivers = ["nvidia"];

# (pkgs.linuxPackages_latest.nvidia_x11.overrideAttrs (old: {
#   version = "555.42.02"; # replace with the latest version number
#   src = pkgs.fetchurl {
#     url = "https://us.download.nvidia.com/XFree86/Linux-x86_64/555.42.02/NVIDIA-Linux-x86_64-555.42.02.run";
#     sha256 = "0aavhxa4jy7jixq1v5km9ihkddr2v91358wf9wk9wap5j3fhidwk";
#   };
# })) 
  #blacklist igpu
  boot.kernelParams = [ "module_blacklist=amdgpu" ];
}
