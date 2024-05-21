{ config, pkgs, lib, pkgs-unstable, vars, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./network-shares.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.kernelPackages = pkgs-unstable.linuxKernel.packages.linux_6_8;
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
    xkb.layout = "us";
    xkb.variant = "";
  };
  users.defaultUserShell = pkgs.zsh;
  users.users.${vars.user} = {
    isNormalUser = true;
    description = "${vars.user}";
    extraGroups = [ "networkmanager" "wheel" "docker" "wireshark" ];
    packages = with pkgs; [];
  };
  environment.sessionVariables = {
    flake_name="vallium";
    FLAKE="$HOME/.flake";
    NIXOS_CONFIG="$HOME/.flake";
    # NIXOS_CONFIG="/home/${vars.user}/.flake";
    QT_STYLE_OVERRIDE="kvantum";
    WLR_NO_HARDWARE_CURSORS = "1"; # look into removing
    NIXOS_OZONE_WL = "1"; #Hint electron apps to use wayland
  };

  #### modules
  gnome.enable = true;
  cosmic-desktop.enable = false;
  virtualization.enable = true;
  devops.enable = true;
  steam.enable = true;
  rar.enable = true;
  thorium.enable = true;
  wg-home.enable = false;
  ai.enable = true;
  builder.enable = true;

  woothing.enable = true;
  finalmouse.enable = true;

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
    remmina           # XRDP & VNC Client
    # sublime-merge
    gparted
    teamspeak_client
    nordic
    papirus-nord
    pciutils # lspci
    pika-backup
  ] ++
    (with pkgs-unstable; [
      vscode
      vscodium
      zed-editor
      wireshark
      # linux
      # orca-slicer
      # openrgb
      # zsh-completions
      # zsh-autocomplete
      godot_4
      kdeconnect
      avahi
      # ollama
      # lmstudio
      # gpt4all
    ]);
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = false;
  };

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      # add any missing dynamic libraries for unpacked programs here, not in the environment.systemPackages
    ];
  };

  ## for setting the default apps
  ## definition https://nix-community.github.io/home-manager/options.xhtml#opt-xdg.mimeApps.defaultApplications
  home-manager.users.${vars.user} = {
    xdg.mime.enable = true;
    xdg.mimeApps.enable = true;
    ## this may be neccesary sometimes
    # xdg.configFile."mimeapps.list".force = true;
    ## from limited testing it is only applied if both sides are valid
    xdg.mimeApps.defaultApplications = {
      "inode/directory" = "org.kde.dolphin.desktop";
    };
  };

  services.flatpak.enable = true;
  services.flatpak.packages = [
      # { appId = "com.brave.Browser"; origin = "flathub";  }
      # "com.obsproject.Studio"
      # "im.riot.Riot"
      "com.github.tchx84.Flatseal"
      "app/org.kicad.KiCad/x86_64/stable"
      "it.mijorus.gearlever"
    ];
  services.flatpak.update.auto = {
    enable = true;
    onCalendar = "daily"; # Default value
  };
  ##
  ##gargabe collection
  programs.dconf.enable = true;

  #finalmouse udev rules for browser access
  services.udev.extraRules = ''
    ACTION=="add", KERNEL=="0000:00:03.0", SUBSYSTEM=="pci", RUN+="/bin/sh -c 'echo 1 > /sys/bus/pci/devices/0000:6c:00.0/remove'"
  '';
  nix.buildMachines = [ {
    hostName = "nixbuilder_dockeropen";
    system = "x86_64-linux";
    protocol = "ssh-ng";
    # if the builder supports building for multiple architectures, 
    # replace the previous line by, e.g.
    # systems = ["x86_64-linux" "aarch64-linux"];
    maxJobs = 2;
    speedFactor = 2;
    supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
    mandatoryFeatures = [ ];
  }] ;
  programs.ssh.extraConfig = ''
    Host nixbuilder_dockeropen
      HostName builder1.nix.local.icylair.com
      Port 22
      User nixbuilder
      IdentitiesOnly yes
      StrictHostKeyChecking no
      IdentityFile ~/.ssh/id_local
  '';


  # virtualisation.oci-containers = {
  #   backend = lib.mkForce "docker";
  #   containers = {
  #     portainer = {
  #       image = "portainer/portainer-ce:2.20.2";
  #       ports = [
  #         "8000:8000"
  #         "9000:9000"
  #         "9443:9443"
  #       ];
  #       volumes = [
  #         "/usr/docker_config/portainer/data:/data"
  #         "/var/run/docker.sock:/var/run/docker.sock"
  #       ];
  #       labels = {
  #         "traefik.enable" = "true";
  #         "traefik.http.routers.portainer.entrypoints" = "http";
  #         "traefik.http.routers.portainer.rule" = "Host(`portainer.icylair.com`)";
  #         "traefik.http.middlewares.portainer-https-redirect.redirectscheme.scheme" = "https";
  #         "traefik.http.routers.portainer.middlewares" = "portainer-https-redirect";
  #         "traefik.http.routers.portainer-secure.entrypoints" = "https";
  #         "traefik.http.routers.portainer-secure.rule" = "Host(`portainer.icylair.com`)";
  #         "traefik.http.routers.portainer-secure.tls" = "true";
  #         "traefik.http.routers.portainer-secure.service" = "portainer";
  #         "traefik.http.services.portainer.loadbalancer.server.port" = "9000";
  #         "traefik.docker.network" = "frontend";
  #       };
  #       networks = {
  #         frontend = {
  #           ipv4Address = "172.18.255.254";
  #         };
  #         vlan11 = {
  #           ipv4Address = "10.2.11.199";
  #         };
  #       };
  #     };
  #   };
  # }; 
}
