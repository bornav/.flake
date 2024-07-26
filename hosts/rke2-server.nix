{ config, lib, system, inputs, node_config, vars, ... }:
let
  pkgs = import inputs.nixpkgs-stable {
    inherit system;
    config.allowUnfree = true;
  };
  pkgs-unstable = import inputs.nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };
in
{
  # k3s specific
  networking.useNetworkd = true;
  networking.firewall.enable = false;  ## this was the shit that was making it fail...
  # networking.firewall = {
  #   allowedTCPPorts = [
  #     6443 # k3s: required so that pods can reach the API server (running on port 6443 by default)
  #     2379 # k3s, etcd clients: required if using a "High Availability Embedded etcd" configuration
  #     2380 # k3s, etcd peers: required if using a "High Availability Embedded etcd" configuration
  #     443
  #     80
  #   ];
  #   allowedTCPPortRanges = [
  #   { from = 4; to = 65535; }
  #   ];
  #   allowedUDPPorts = [
  #     8472 # k3s, flannel: required if using multi-node for inter-node networking
  #     443
  #     80
  #   ];
  #   allowedUDPPortRanges = [
  #   { from = 4; to = 65535; }
  #   ];
  # };
  # # Given that our systems are headless, emergency mode is useless.
  # # We prefer the system to attempt to continue booting so
  # # that we can hopefully still access it remotely.
  # systemd.enableEmergencyMode = false;
  system.activationScripts.usrlocalbin = ''  
      mkdir -m 0755 -p /usr/local
      ln -nsf /run/current-system/sw/bin /usr/local/
  ''; # TODO look into, potentialy undeeded
  systemd.tmpfiles.rules = [
    "L+ /usr/local/bin - - - - /run/current-system/sw/bin/"
  ];
  systemd.watchdog.rebootTime = "3m";

  environment.etc."rancher/rke2/config.yaml".source = pkgs.writeText "config.yaml" node_config;
  services.rke2 = {
    package = pkgs-unstable.rke2_latest;
    # clusterInit=true;
    # role="server";
    tokenFile ="/var/token";
    enable = true;
    # cni = "cilium";
    cni = "none";

    # extraFlags = toString ([
	  #   "--write-kubeconfig-mode \"0644\""
	  #   "--disable rke2-kube-proxy"
	  #   "--disable rke2-canal"
	  #   "--disable rke2-coredns"
    #   "--disable rke2-ingress-nginx"
    #   "--disable rke2-metrics-server"
    #   "--disable rke2-service-lb"
    #   "--disable rke2-traefik"
    # ] ++ (if meta.hostname == "homelab-0" then [] else [
	  #     "--server https://homelab-0:6443"
    # ]));
  };

  services.openiscsi = {
    enable = true;
    name = "iqn.2000-05.edu.example.iscsi:${config.networking.hostName}";
  };
  # services.nfs.server.enable = true;
  environment.systemPackages = with pkgs; [
    nfs-utils
    wireguard-tools
    python3
    cilium-cli
    cni-plugins
    cifs-utils
    git
    kubectl
    # k3s_1_30
    vim
    nano
    # rke2
    k9s

    util-linux ## longhorn nsenter, seems nsenter is available without this

  ];
  boot.supportedFilesystems = [
    "ext4"
    "btrfs"
    "xfs"
    #"zfs"
    "ntfs"
    "fat"
    "vfat"
    "exfat"
    "nfs" # required by longhorn
  ];
  services.rpcbind.enable = true;
  services.kubernetes.apiserver.allowPrivileged = true;
  boot.kernelModules = [ "rbd" "br_netfilter" ];

  virtualisation.docker.logDriver = "json-file";
  # virtualisation.containerd = {
  #   enable = true;
  #   # settings =
  #   #   let
  #   #     fullCNIPlugins = pkgs.buildEnv {
  #   #       name = "full-cni";
  #   #       paths = with pkgs;[
  #   #         cni-plugins
  #   #         cni-plugin-flannel
  #   #       ];
  #   #     };
  #   #   in {
  #   #     plugins."io.containerd.grpc.v1.cri".cni = {
  #   #       bin_dir = "${fullCNIPlugins}/bin";
  #   #       conf_dir = "/var/lib/rancher/k3s/agent/etc/cni/net.d/";
  #   #     };
  #   #     # Optionally set private registry credentials here instead of using /etc/rancher/k3s/registries.yaml
  #   #     # plugins."io.containerd.grpc.v1.cri".registry.configs."registry.example.com".auth = {
  #   #     #  username = ""; 
  #   #     # };
  #   # };
  # }; 


  # TODO lookinto
  # https://github.com/ryan4yin/nix-config/blob/36ba5a4efcc523f45f391342ef49bee07261c22d/lib/genKubeVirtHostModule.nix#L62
  # boot.kernel.sysctl = {
  #   # --- filesystem --- #
  #   # increase the limits to avoid running out of inotify watches
  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = 524288;
    "fs.inotify.max_user_instances" = 1024;

  #   # --- network --- #

    # net.ipv4.ip_local_reserved_ports=30000-32767
    "net.bridge.bridge-nf-call-iptables"=1;
    "net.bridge.bridge-nf-call-arptables"=1;
    "net.bridge.bridge-nf-call-ip6tables"=1;
    "net.core.somaxconn" = 32768;
    "net.ipv4.ip_forward" = 1;
    "net.ipv4.conf.all.forwarding" = 1;
    "net.ipv4.neigh.default.gc_thresh1" = 4096;
    "net.ipv4.neigh.default.gc_thresh2" = 6144;
    "net.ipv4.neigh.default.gc_thresh3" = 8192;
    "net.ipv4.neigh.default.gc_interval" = 60;
    "net.ipv4.neigh.default.gc_stale_time" = 120;

    "net.ipv4.conf.all.send_redirects"=0;
    # net.ipv4.conf.default.send_redirects=0
    # net.ipv4.conf.default.accept_source_route=0
    "net.ipv4.conf.all.accept_redirects"=0;
    # net.ipv4.conf.default.accept_redirects=0
    # net.ipv4.conf.all.log_martians=1
    # net.ipv4.conf.default.log_martians=1
    # net.ipv4.conf.all.rp_filter=1
    # net.ipv4.conf.default.rp_filter=1

    # "net.ipv6.conf.all.disable_ipv6" = 1; # disable ipv6
    # net.ipv6.conf.all.accept_ra=0
    # net.ipv6.conf.default.accept_ra=0
    # net.ipv6.conf.all.accept_redirects=0
    # net.ipv6.conf.default.accept_redirects=0
    "kernel.keys.root_maxbytes"=25000000;
    "kernel.keys.root_maxkeys"=1000000;
    "kernel.panic"=10;
    "kernel.panic_on_oops"=1;
    "vm.overcommit_memory"=1;
    "vm.panic_on_oom"=0;
    "vm.swappiness" = 0; # don't swap unless absolutely necessary
  };
}
