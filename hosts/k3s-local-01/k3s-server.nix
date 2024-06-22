{ config, lib, inputs, vars, ... }:
let
  system = "x86_64-linux";
  pkgs = import inputs.nixpkgs-stable {
    inherit system;
    config.allowUnfree = true;
  };
  pkgs-unstable = import inputs.nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };
  master3 = ''
    ---
    #master3
    token: xxxxxxx
    flannel-backend: none
    disable-kube-proxy: true
    disable-network-policy: true
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
    server: https://10.99.10.12:6443
    node-ip: 10.99.10.10
  '';
  master4 = ''
    ---
    #master3
    token: xxxxxxx
    flannel-backend: none
    disable-kube-proxy: true
    disable-network-policy: true
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
    node-ip: 10.2.11.25
  '';
in
{

  # k3s specific
  environment.etc."rancher/k3s/config.yaml".source = pkgs.writeText "config.yaml" master4;
  systemd.network.enable = true;
  networking.firewall = {
    allowedTCPPorts = [
      6443 # k3s: required so that pods can reach the API server (running on port 6443 by default)
      2379 # k3s, etcd clients: required if using a "High Availability Embedded etcd" configuration
      2380 # k3s, etcd peers: required if using a "High Availability Embedded etcd" configuration
      443
      80
    ];
    allowedTCPPortRanges = [
    { from = 4; to = 65535; }
    ];
    allowedUDPPorts = [
      8472 # k3s, flannel: required if using multi-node for inter-node networking
      443
      80
    ];
    allowedUDPPortRanges = [
    { from = 4; to = 65535; }
    ];
  };
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
    name = "${config.networking.hostName}-initiatorhost";
  };
  environment.systemPackages = with pkgs; [
    nfs-utils
    wireguard-tools
    python3
    
    kubectl
    rke2
    k9s
  ];
  boot.supportedFilesystems = [ "nfs" ];
  services.rpcbind.enable = true;
  services.kubernetes.apiserver.allowPrivileged = true;
  virtualisation.docker.logDriver = "json-file";
  boot.kernelModules = [ "rbd" "br_netfilter" ];
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  virtualisation.containerd = {
    enable = true;
    # settings =
    #   let
    #     fullCNIPlugins = pkgs.buildEnv {
    #       name = "full-cni";
    #       paths = with pkgs;[
    #         cni-plugins
    #         cni-plugin-flannel
    #       ];
    #     };
    #   in {
    #     plugins."io.containerd.grpc.v1.cri".cni = {
    #       bin_dir = "${fullCNIPlugins}/bin";
    #       conf_dir = "/var/lib/rancher/k3s/agent/etc/cni/net.d/";
    #     };
    #     # Optionally set private registry credentials here instead of using /etc/rancher/k3s/registries.yaml
    #     # plugins."io.containerd.grpc.v1.cri".registry.configs."registry.example.com".auth = {
    #     #  username = "";
    #     #  password = "";
    #     # };
    # };
  }; 
}
