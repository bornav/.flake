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
in
{

  # k3s specific

  networking.firewall.allowedTCPPorts = [
    6443 # k3s: required so that pods can reach the API server (running on port 6443 by default)
    2379 # k3s, etcd clients: required if using a "High Availability Embedded etcd" configuration
    2380 # k3s, etcd peers: required if using a "High Availability Embedded etcd" configuration
    443
    80
  ];
  networking.firewall.allowedUDPPorts = [
    8472 # k3s, flannel: required if using multi-node for inter-node networking
    443
    80
  ];
  services.k3s = {
    enable = true;
    role = "server";
    token = "<randomized common secret>";
    # clusterInit = true;
    extraFlags = toString [
      "--container-runtime-endpoint unix:///run/containerd/containerd.sock"
    # "--kubelet-arg=v=4" # Optionally add additional args to k3s
    ];
    # serverAddr = "https://<ip of first node>:6443";
  };
  services.openiscsi = {
    enable = true;
    name = "${config.networking.hostName}-initiatorhost";
  };
  environment.systemPackages = with pkgs; [
    nfs-utils
  ];
  boot.supportedFilesystems = [ "nfs" ];
  services.rpcbind.enable = true;
  boot.kernelModules = [ "rbd" ];
  virtualisation.containerd = {
    enable = true;
    settings =
      let
        fullCNIPlugins = pkgs.buildEnv {
          name = "full-cni";
          paths = with pkgs;[
            cni-plugins
            cni-plugin-flannel
          ];
        };
      in {
        plugins."io.containerd.grpc.v1.cri".cni = {
          bin_dir = "${fullCNIPlugins}/bin";
          conf_dir = "/var/lib/rancher/k3s/agent/etc/cni/net.d/";
        };
        # Optionally set private registry credentials here instead of using /etc/rancher/k3s/registries.yaml
        # plugins."io.containerd.grpc.v1.cri".registry.configs."registry.example.com".auth = {
        #  username = "";
        #  password = "";
        # };
      };
  };


  
}
