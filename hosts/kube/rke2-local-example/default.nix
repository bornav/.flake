{ config, lib, system, inputs, host, vars, ... }:
let
  pkgs = import inputs.nixpkgs-stable {
    system = host.system;
    config.allowUnfree = true;
  };
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = host.system;
    config.allowUnfree = true;
  };
  master3 = ''
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
    node-ip: 10.99.10.13
    server: https://10.99.10.11:6443
  '';
  master3_rke = ''
    ---
    write-kubeconfig-mode: "0644"
    disable:
      - rke2-canal
      - rke2-ingress-nginx
      - rke2-service-lb
    tls-san:
      - 10.0.0.71
      - 10.0.0.100
      - 10.2.11.24
      - 10.2.11.25
      - 10.2.11.36
      - 10.2.11.38
      - 10.99.10.15
      - 10.99.10.14
      - 10.99.10.13
      - 10.99.10.12
      - 10.99.10.11
      - 10.99.10.10
      - lb.cloud.icylair.com
      - oraclearm1.cloud.icylair.com
      - oraclearm2.cloud.icylair.com
      - k3s-local-01.local.icylair.com
      - k3s-local-01
      - k3s-local-02.local.icylair.com
      - k3s-local-02
      - k3s-oraclearm1
      - k3s-oraclearm2
    node-label:
      - "node-location=local"
      - "node-arch=amd64"
    kube-apiserver-arg:
      - oidc-issuer-url=https://keycloak.cloud.icylair.com/realms/master
      - oidc-client-id=kubernetes
      - oidc-username-claim=email
      - oidc-groups-claim=groups
    node-taint:
      - "node-role.kubernetes.io/control-plane=true:NoSchedule"
    node-ip: 10.99.10.13
    server: https://10.99.10.11:9345
  '';
    # runtime-image: "index.docker.io/rancher/rke2-runtime:v1.30.1-rke2r1"
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
    (import ../rke2-server.nix {inherit inputs vars config lib host system;node_config  = master3_rke;})
    {_module.args.disks = [ "/dev/sda" ];}
  ];
  rke2.server = true;
  boot.loader = {
    timeout = 1;
    grub.enable = true;
    grub.device = "nodev";
    grub.efiSupport = true;
    grub.efiInstallAsRemovable = lib.mkForce true;
  };
  systemd.network.wait-online.enable = false;
  boot.initrd.systemd.network.wait-online.enable = false;
  services.journald = {
    extraConfig = ''
      SystemMaxUse=50M      # Maximum disk usage for the entire journal
      SystemMaxFileSize=50M # Maximum size for individual journal files
      RuntimeMaxUse=50M     # Maximum disk usage for runtime journal
      MaxRetentionSec=1month # How long to keep journal files
    '';
  };
}
