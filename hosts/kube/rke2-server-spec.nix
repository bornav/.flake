{ config, lib, system, inputs, host, node_config, vars, ... }:
let
  # inherit host;
  pkgs = import inputs.nixpkgs-stable {
    system = host.system;
    config.allowUnfree = true;
  };
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = host.system;
    config.allowUnfree = true;
  };
  # customRke2 = pkgs.stdenv.mkDerivation rec { does download but does not install
  #   pname = "rke2";
  #   version = "v1.30.1"; # Replace with your desired version
  #   src = pkgs.fetchurl {
  #     url = "https://github.com/rancher/rke2/releases/download/v1.30.3%2Brke2r1/rke2-images.linux-amd64.tar.gz";
  #     sha256 = "sha256-drkOSTfXVYm1SvFJDr0xechi1HMyT7JzrtezZ+r0piU="; # Replace with the actual sha256 of the archive
  #   };
  #   buildInputs = [ pkgs.libarchive pkgs.stdenv ];
  #   installPhase = ''
  #     mkdir -p $out/bin
  #     tar -xzf $src -C $out/bin --strip-components=1
  #   '';
  # };
in
{
  options = {
    rke2 = {
      server = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      agent = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };
  config = lib.mkMerge [
    (lib.mkIf (config.rke2.server) {
      services.rke2 = {
        package = pkgs-unstable.rke2_latest;
        # package = pkgs.rke2;
        # clusterInit=true;
        role="server";
        tokenFile ="/var/token";
        enable = true;
        # cni = "cilium";
        cni = "none";
        extraFlags = [ # space at the start important ! :|
          # " --disable rke2-kube-proxy"
          " --kube-apiserver-arg default-not-ready-toleration-seconds=30"
          " --kube-apiserver-arg default-unreachable-toleration-seconds=30" 
          " --kube-controller-manager-arg node-monitor-period=20s"
          " --kube-controller-manager-arg node-monitor-grace-period=20s" 
          " --kubelet-arg node-status-update-frequency=5s"
        ];
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
    })
    (lib.mkIf (config.rke2.agent) {
      services.rke2 = {
        package = pkgs-unstable.rke2_latest;
        role="agent";
        tokenFile ="/var/token";
        enable = true;
        serverAddr = https://10.99.10.11:9345;
        # configPath = "/etc/rancher/rke2/config.yaml";
        extraFlags = [ # space at the start important ! :|
          # " --disable rke2-kube-proxy"
          " --kube-apiserver-arg default-not-ready-toleration-seconds=30"
          " --kube-apiserver-arg default-unreachable-toleration-seconds=30" 
          " --kube-controller-manager-arg node-monitor-period=20s"
          " --kube-controller-manager-arg node-monitor-grace-period=20s" 
          " --kubelet-arg node-status-update-frequency=5s"
        ];
      };
    })
  ]; 
}
