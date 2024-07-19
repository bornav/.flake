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
  master4 = ''
    ---
    #master3
    token: xxxxxxx
    cluster-init: true
    write-kubeconfig-mode: "0644"
    disable:
      - rke2-kube-proxy
      - rke2-canal
      - rke2-coredns
      - rke2-ingress-nginx
      - rke2-metrics-server
      - rke2-service-lb
      - rke2-traefik
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
    node-ip: 10.2.11.36
  '';
in
{

  # environment.etc."rancher/rke2/config.yaml".source = pkgs.writeText "config.yaml" master4;
  # services.rke2 = {
  #   package = pkgs.rke2;
  #   enable = true;
  #   # cni = "cilium";
  #   cni = "none";
  # };

}
