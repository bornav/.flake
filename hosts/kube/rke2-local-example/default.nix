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
  token = ''
  this-is-temp-token
  '';
  master3_rke = ''
    ---
    write-kubeconfig-mode: "0644"
    disable:
      - rke2-canal
      - rke2-ingress-nginx
      - rke2-service-lb
    tls-san:
      - rke2-local-example.local.icylair.com
      - lb.local.icylair.com
      - lb.cloud.icylair.com
      - oraclearm1.cloud.icylair.com
      - oraclearm2.cloud.icylair.com
      - k3s-local-01.local.icylair.com
      - k3s-local-01
      - k3s-local-02.local.icylair.com
      - k3s-local-02
      - k3s-oraclearm1
      - k3s-oraclearm2
    disable-kube-proxy: true
    node-label:
      - "node-location=local"
      - "node-arch=amd64"
    kube-apiserver-arg:
      - oidc-issuer-url=https://keycloak.cloud.icylair.com/realms/master
      - oidc-client-id=kubernetes
      - oidc-username-claim=email
      - oidc-groups-claim=groups
    # node-taint:
    #   - "node-role.kubernetes.io/control-plane=true:NoSchedule"
    node-ip: 10.2.11.41
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
  environment.etc."rancher/rke2/token".source = pkgs.writeText "token" token;
  services.rke2.tokenFile = lib.mkForce "/etc/rancher/rke2/token";
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
