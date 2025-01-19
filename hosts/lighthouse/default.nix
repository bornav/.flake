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
        use_backend headscale_backend if { req_ssl_sni -i headscale.icylair.com }
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

    frontend 6443-forward
        bind *:6443
        mode tcp
        option tcplog
        default_backend 6443_backends
    backend 6443_backends
        mode tcp
        balance roundrobin
        server server1 oraclearm1.cloud.icylair.com:6443 check
        server server2 oraclearm2.cloud.icylair.com:6443 check

    frontend 80-forward
        bind *:80
        mode tcp
        option tcplog
        default_backend 80_backends
    backend 80_backends
        mode tcp
        balance roundrobin
        server server1 oraclearm1.cloud.icylair.com:80 check
        server server2 oraclearm2.cloud.icylair.com:80 check

    frontend ssh-forward
        bind *:10022
        mode tcp
        option tcplog
        default_backend ssh_forward_backend
    backend ssh_forward_backend
        mode tcp
        balance roundrobin
        server server1 oraclearm1.cloud.icylair.com:22 check
        server server2 oraclearm2.cloud.icylair.com:22 check

    backend headscale_backend
        mode tcp
        server server1 127.0.0.1:10023

    # frontend udp-9987
    #     bind *:9987 udp
    #     mode tcp
    #     option tcplog
    #     default_backend udp_9987_backend
    # backend udp_9987_backend
    #     mode tcp
    #     balance roundrobin
    #     server server1 oraclearm1.cloud.icylair.com:9987 check
    #     server server2 oraclearm2.cloud.icylair.com:9987 check
    frontend tcp-30033
        bind *:30033
        mode tcp
        option tcplog
        default_backend tcp_30033_backend
    backend tcp_30033_backend
        mode tcp
        balance roundrobin
        server server1 oraclearm1.cloud.icylair.com:30033 check
        server server2 oraclearm2.cloud.icylair.com:30033 check

    # frontend headscale
    #     bind *:8080
    #     mode tcp
    #     option tcplog
    #     default_backend headscale_backend
    # frontend catch_rest
    #     # bind *:1-21
    #     bind *:8443-65535
    #     mode tcp
    #     option tcplog
    #     default_backend catch_rest
    # backend catch_rest
    #     mode tcp
    #     balance roundrobin
    #     server server1 oraclearm1.cloud.icylair.com check
    #     server server2 oraclearm2.cloud.icylair.com check
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
    package = pkgs.nixVersions.stable;
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
    allowedTCPPorts = [ 22 80 443 6443 8080 10022];
    allowedUDPPortRanges = [
      { from = 1000; to = 6550; }
    ];
  };

  # #ipv6
  # # networking.interfaces.eth0.name = "eth0";
  # networking = {
  #   interfaces.eth0 = {
  #     name = "eth0";
  #     useDHCP = true;
  #     ipv6 = {
  #       addresses = [ "2001:db8:0:3df1::1/64" ];
  #       routes = [
  #         {
  #           to = "default";
  #           via = "fe80::1";
  #         }
  #       ];
  #     };
  #   };
  # };
  # networking.nameservers = {
  #   ipv6 = {
  #     addresses = [ "2a01:4ff:ff00::add:2" "2a01:4ff:ff00::add:1" ];
  #   };
  # };
  # ####
  # services.caddy = {
  #   enable = true;
  #   virtualHosts."lb.cloud.icylair.com".extraConfig = ''
  #     reverse_proxy * 127.0.0.1:8080
  #   '';
  # };
  services.headscale = {
    enable = true;
    address = "0.0.0.0";
    port = 10023;
    settings = {
      log.level = "debug";
      server_url = "https://headscale.icylair.com:8080";
      dns.base_domain = "icylair-local.com";
      tls_cert_path = "/certs/tls.crt";
      tls_key_path = "/certs/tls.key";
      oidc = {
        issuer = "https://sso.icylair.com/realms/master";
        client_id = "headscale";
        client_secret_path = "/headscale_key";
      };
    };
  };
  # networking.firewall.trustedInterfaces = [config.services.tailscale.interfaceName];
} 
