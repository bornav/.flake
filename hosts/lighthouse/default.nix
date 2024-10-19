{ config, lib, host, inputs, ... }:
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
      home-manager.useUserPackages = true;}
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.nix-flatpak.nixosModules.nix-flatpak
    inputs.disko.nixosModules.disko
    ./hardware-configuration.nix
    ./disk-config.nix
    {_module.args.disks = [ "/dev/sda" ];}
  ];
  
  # boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.kernelPackages = pkgs-unstable.linuxKernel.packages.linux_6_8;
  boot.kernelModules = [ "rbd" "br_netfilter" ];
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  boot.loader = {
    timeout = 1;
    grub.enable = true;
    grub.efiSupport = true;
    grub.efiInstallAsRemovable = true;
  };
  # services.nginx.enable = true;
  # services.nginx.config = ''
  #   events {
  #       worker_connections 1024;  # You can adjust this based on your expected traffic
  #   }

  #   stream {
  #       # Define the upstream (backend) servers
  #       upstream backend_servers {
  #           # The two HTTPS servers (port 443)
  #           server 138.3.244.139:443;
  #           server 141.144.255.9:443;
  #       }

  #       # Define the proxy server
  #       server {
  #           # The port on which NGINX will listen for HTTPS connections
  #           listen 443;
  #           proxy_pass backend_servers;

  #           # Enable proxying the SSL/TLS traffic without terminating it (TLS passthrough)
  #           proxy_protocol off;  # Disables Proxy Protocol if enabled by upstream
  #       }
  #   }
  # '';


  services.haproxy.enable = true;
  services.haproxy.config = ''
    global
        log /dev/log    local0
        log /dev/log    local1 notice
        # chroot /var/lib/haproxy
        stats socket /run/haproxy/admin.sock mode 660 level admin
        stats timeout 30s
        user haproxy
        group haproxy
        daemon

        # SSL-related options to improve performance and security
        tune.ssl.default-dh-param 2048

    # Default settings
    defaults
        log     global
        option  tcplog
        option  dontlognull
        timeout connect 5s
        timeout client  30s
        timeout server  30s

    # Frontend for TLS passthrough
    frontend https-in
        bind *:443
        mode tcp
        option tcplog
        tcp-request inspect-delay 5s
        tcp-request content accept if { req_ssl_hello_type 1 }

        # Load balancing between two backend servers
        default_backend tls_backends

    # Backend servers (TLS termination happens here)
    backend tls_backends
        mode tcp
        balance roundrobin
        option ssl-hello-chk

        # Define the backend servers
        server server1 oraclearm1.cloud.icylair.com:443 check
        server server2 oraclearm2.cloud.icylair.com:443 check
    '';
  networking.hostName = host.hostName; # Define your hostname.
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
  users.users.${host.vars.user} = {
    isNormalUser = true;
    initialPassword = "nixos";
    description = "${host.vars.user}";
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
    vim
    haproxy
    nfs-utils
    wireguard-tools
    python3
    cilium-cli
    cni-plugins
    cifs-utils
    git
    kubectl
    vim
    nano
    k9s
    inetutils
    nettools
    util-linux
  ];
  system.stateVersion = "${host.vars.stateVersion}";
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
  # systemd.network.networks."10-wan" = {
  #   matchConfig.Name = "enp1s0";
  #   networkConfig = {
  #     # start a DHCP Client for IPv4 Addressing/Routing
  #     DHCP = "ipv4";
  #     # accept Router Advertisements for Stateless IPv6 Autoconfiguraton (SLAAC)
  #     IPv6AcceptRA = true;
  #   };
  #   # make routing on this interface a dependency for network-online.target
  #   linkConfig.RequiredForOnline = "routable";
  # };
  # wirenix = {
  #   enable = true;
  #   peerName = "node1"; # defaults to hostname otherwise
  #   configurer = "static"; # defaults to "static", could also be "networkd"
  #   keyProviders = ["acl"]; # could also be ["agenix-rekey"] or ["acl" "agenix-rekey"]
  #   # secretsDir = ./secrets; # only if you're using agenix-rekey
  #   aclConfig = import ./mesh.nix;
  # };

  # networking.nat.forwardPorts = 
  # [
  #   {
  #     destination = "oraclearm2.cloud.icylair.com:80";
  #     proto = "tcp";
  #     sourcePort = 80;
  #   }
  #   {
  #     destination = "oraclearm2.cloud.icylair.com:443";
  #     proto = "tcp";
  #     sourcePort = 443;
  #   }
  # ];

  networking.firewall = {
  enable = true;
  allowedTCPPorts = [ 80 443 ];
  allowedUDPPortRanges = [
    { from = 1000; to = 6550; }
  ];
};

}
