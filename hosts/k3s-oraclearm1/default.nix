{ config, lib, inputs, vars, ... }:
let
  system = "aarch64-linux";
  pkgs = import inputs.nixpkgs-stable {
    inherit system;
    config.allowUnfree = true;
  };
  pkgs-unstable = import inputs.nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };
  master2 = ''
    ---
    token: xx
    flannel-backend: none
    disable-kube-proxy: true
    disable-network-policy: true
    write-kubeconfig-mode: "0644"
    cluster-init: true
    disable:
      - servicelb
      - traefik
    tls-san:
      - 10.0.0.71
      - 10.0.0.100
      - 10.2.11.24
      - 10.2.11.25
      - 10.2.11.36
      - 10.99.10.12
      - 10.99.10.11
      - 10.99.10.10
      - lb.cloud.icylair.com
      - oraclearm1.cloud.icylair.com
      - oraclearm2.cloud.icylair.com
      - k3s-local-01.local.icylair.com
      - k3s-local-01
      - k3s-local.local.icylair.com
      - k3s-local
    node-ip: 10.99.10.12
    server: https://10.99.10.11:6443
  '';
  master2_rke = ''
    write-kubeconfig-mode: "0644"
    disable:
      - rke2-kube-proxy
      - rke2-canal
      - rke2-ingress-nginx
      - rke2-metrics-server
      - rke2-service-lb
    tls-san:
      - 10.0.0.71
      - 10.0.0.100
      - 10.2.11.24
      - 10.2.11.25
      - 10.2.11.36
      - 10.99.10.12
      - 10.99.10.11
      - 10.99.10.10
      - lb.cloud.icylair.com
      - oraclearm1.cloud.icylair.com
      - oraclearm2.cloud.icylair.com
      - k3s-local-01.local.icylair.com
      - k3s-local-01
      - k3s-local.local.icylair.com
      - k3s-local
      - k3s-oraclearm1
      - k3s-oraclearm2
    node-ip: 10.99.10.12 
    server: https://10.99.10.11:9345
  '';
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;}
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.nix-flatpak.nixosModules.nix-flatpak
    inputs.disko.nixosModules.disko
    # inputs.wirenix.nixosModules.default
    ./hardware-configuration.nix
    ./disk-config.nix
    # (import ../k3s-server.nix {inherit inputs vars config lib system;node_config = master2;})
    (import ../rke2-server.nix {inherit inputs vars config lib system;node_config = master2_rke;})
    # ./k3s-server.nix
    # ./mesh.nix
    {_module.args.disks = [ "/dev/sda" ];}
  ];

  fileSystems."/storage" =
    { device = "/dev/disk/by-uuid/2ef3f9ea-c3a7-4be2-903a-b4476c1f56c2";
      fsType = "ext4";
      options = [
        "noatime"
      ];
    };

  # boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.kernelPackages = pkgs-unstable.linuxKernel.packages.linux_6_8;
  boot.loader = {
    timeout = 1;
    grub.enable = true;
    grub.device = "nodev";
    # efi.canTouchEfiVariables = true;
    # grub.efiInstallAsRemovable = lib.mkForce false;
    grub.efiSupport = true;
    grub.efiInstallAsRemovable = lib.mkForce true;
  };

  systemd.network.networks."10-wan" = {
    matchConfig.Name = "enp1s0";
    networkConfig = {
      # start a DHCP Client for IPv4 Addressing/Routing
      DHCP = "ipv4";
      # accept Router Advertisements for Stateless IPv6 Autoconfiguraton (SLAAC)
      IPv6AcceptRA = true;
    };
    # make routing on this interface a dependency for network-online.target
    linkConfig.RequiredForOnline = "routable";
  };

  networking.hostName = "k3s-oraclearm1"; # Define your hostname.
  networking.networkmanager.enable = true;
  programs.nh.enable = true;
  services = {
    openssh = {                             # SSH
      enable = true;
      allowSFTP = true;                     # SFTP
      extraConfig = ''
        HostKeyAlgorithms +ssh-rsa
      '';
      settings.PasswordAuthentication = true;
      settings.KbdInteractiveAuthentication = true;
      settings.PermitRootLogin = "yes";
    };
    xserver = {
      xkb.layout = "us";
      xkb.variant = "";
    };
  };
  users.users.root.openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEGiVyNsVCk2KAGfCGosJUFig6PyCUwCaEp08p/0IDI7"];
  users.users.root.initialPassword = "nixos";
  users.users.${vars.user} = {
    isNormalUser = true;
    initialPassword = "nixos";
    description = "${vars.user}";
    extraGroups = [ "networkmanager" "wheel" "docker"];
    # packages = with pkgs; [];
    openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEGiVyNsVCk2KAGfCGosJUFig6PyCUwCaEp08p/0IDI7"];
  };
  time.timeZone = "Europe/Vienna";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "de_AT.UTF-8";
      LC_IDENTIFICATION = "de_AT.UTF-8";
      LC_MEASUREMENT = "de_AT.UTF-8";
      LC_MONETARY = "de_AT.UTF-8";
      LC_NAME = "de_AT.UTF-8";
      LC_NUMERIC = "de_AT.UTF-8";
      LC_PAPER = "de_AT.UTF-8";
      LC_TELEPHONE = "de_AT.UTF-8";
      LC_TIME = "de_AT.UTF-8";
    };
  };
  environment.sessionVariables = {
    flake_name="k3s-oraclearm1";
    FLAKE="$HOME/.flake";
    NIXOS_CONFIG="$HOME/.flake";
    # NIXOS_CONFIG="/home/${vars.user}/.flake";
  };

  ####
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    jq
    gparted
    pciutils # lspci
    zip
    p7zip
    unzip
    unrar
    gnutar
    ser2net
    par2cmdline
    rsync
  ];
  system = {                                # NixOS Settings
    # autoUpgrade = {                        # Allow Auto Update (not useful in flakes)
    #  enable = true;
    #  flake = inputs.self.outPath;
    #  flags = [
    #    "--update-input"
    #    "nixpkgs"
    #    "-L"
    #  ];
    # };
    stateVersion = "${vars.stateVersion}";
  };
  systemd.extraConfig = ''
    DefaultTimeoutStopSec=20s
  ''; # sets the systemd stopjob timeout to somethng else than 90 seconds
  nix = {
    settings.auto-optimise-store = true;
    gc = {                                  # Garbage Collection
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
    settings.max-jobs = 4;
  };

  # environment.variables = {
  #   LD_LIBRARY_PATH=lib.mkForce "$NIX_LD_LIBRARY_PATH"; ## may break stuff
  # };
  # programs.nix-ld = {
  #   enable = true;
  #   libraries = with pkgs; [
  #     alsa-lib
  #     at-spi2-atk
  #     at-spi2-core
  #     atk
  #     cairo
  #     cups
  #     curl
  #     dbus
  #     expat
  #     fontconfig
  #     freetype
  #     fuse3
  #     gdk-pixbuf
  #     glib
  #     gtk3
  #     icu
  #     libGL
  #     libappindicator-gtk3
  #     libdrm
  #     libglvnd
  #     libnotify
  #     libpulseaudio
  #     libunwind
  #     libusb1
  #     libuuid
  #     libxkbcommon
  #     libxml2
  #     mesa
  #     nspr
  #     nss
  #     openssl
  #     pango
  #     pipewire
  #     stdenv.cc.cc
  #     systemd
  #     vulkan-loader
  #     xorg.libX11
  #     xorg.libXScrnSaver
  #     xorg.libXcomposite
  #     xorg.libXcursor
  #     xorg.libXdamage
  #     xorg.libXext
  #     xorg.libXfixes
  #     xorg.libXi
  #     xorg.libXrandr
  #     xorg.libXrender
  #     xorg.libXtst
  #     xorg.libxcb
  #     xorg.libxkbfile
  #     xorg.libxshmfence
  #     zlib
  #     # add any missing dynamic libraries for unpacked programs here, not in the environment.systemPackages
  #   ];
  # };

  # wirenix = {
  #   enable = true;
  #   peerName = "node1"; # defaults to hostname otherwise
  #   configurer = "static"; # defaults to "static", could also be "networkd"
  #   keyProviders = ["acl"]; # could also be ["agenix-rekey"] or ["acl" "agenix-rekey"]
  #   # secretsDir = ./secrets; # only if you're using agenix-rekey
  #   aclConfig = import ./mesh.nix;
  # };
}
