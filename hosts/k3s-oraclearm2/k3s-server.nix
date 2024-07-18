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
  master1 = ''
    ---
    #master1
    token: xxxx
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
    node-ip: 10.99.10.11
  '';
in
{

  # k3s specific
  networking.useNetworkd = true;
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
  # environment.etc."rancher/rke2/config.yaml".source = pkgs.writeText "config.yaml" master4;
  # services.rke2 = {
  #   package = pkgs.rke2;
  #   enable = true;
  #   # cni = "cilium";
  #   cni = "none";
  # };

  # # Given that our systems are headless, emergency mode is useless.
  # # We prefer the system to attempt to continue booting so
  # # that we can hopefully still access it remotely.
  # systemd.enableEmergencyMode = false;
  system.activationScripts.usrlocalbin = ''
      mkdir -m 0755 -p /usr/local
      ln -nsf /run/current-system/sw/bin /usr/local/
  '';
  systemd.tmpfiles.rules = [
    "L+ /usr/local/bin - - - - /run/current-system/sw/bin/"
  ];
  environment.etc."rancher/k3s/config.yaml".source = pkgs.writeText "config.yaml" master1;
  services.k3s = {
    package = pkgs.k3s_1_30;
    enable = true;
    # # role = "server";
    # # token = "<randomized common secret>";
    # # clusterInit = true;
    # # extraFlags = toString [
    # #   "--container-runtime-endpoint unix:///run/containerd/containerd.sock"
    # # # "--kubelet-arg=v=4" # Optionally add additional args to k3s
    # # ];
    configPath = "/etc/rancher/k3s/config.yaml";
    # # serverAddr = "https://<ip of first node>:6443";
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
    k3s_1_30
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
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

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
  #   "fs.inotify.max_user_watches" = 524288;
  #   "fs.inotify.max_user_instances" = 1024;

  #   # --- network --- #
  #   "net.bridge.bridge-nf-call-iptables" = 1;
  #   "net.core.somaxconn" = 32768;
  #   "net.ipv4.ip_forward" = 1;
  #   "net.ipv4.conf.all.forwarding" = 1;
  #   "net.ipv4.neigh.default.gc_thresh1" = 4096;
  #   "net.ipv4.neigh.default.gc_thresh2" = 6144;
  #   "net.ipv4.neigh.default.gc_thresh3" = 8192;
  #   "net.ipv4.neigh.default.gc_interval" = 60;
  #   "net.ipv4.neigh.default.gc_stale_time" = 120;

  #   "net.ipv6.conf.all.disable_ipv6" = 1; # disable ipv6

  #   # --- memory --- #
  #   "vm.swappiness" = 0; # don't swap unless absolutely necessary
  # };
}
