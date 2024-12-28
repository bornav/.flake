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
  master_rke = ''
    ---
    write-kubeconfig-mode: "0644"
    disable:
      - rke2-canal
      - rke2-ingress-nginx
      - rke2-service-lb
    tls-san:
      - rke2-local.local.icylair.com
      - 10.2.11.42
    disable-kube-proxy: true
    node-label:
      - "node-location=local"
      - "node-arch=amd64"
    # node-taint:
    #   - "node-role.kubernetes.io/control-plane=true:NoSchedule"
    node-ip: 10.2.11.42
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
    # (import ../k3s-server.nix {inherit inputs vars config lib system;node_config = master3;})
    (import ../rke2-server.nix {inherit inputs vars config lib host system;node_config  = master_rke;})
    # ./k3s-server.nix
    {_module.args.disks = [ "/dev/sda" ];}
  ];
  rke2.server = true;
  # rke2.agent = true;

  # boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.kernelPackages = pkgs-unstable.linuxKernel.packages.linux_6_8;
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


  fileSystems."/kubernetes" = {#truenas nfs storage
        device = "10.2.11.200:/mnt/vega/vega/kubernetes";
        fsType = "nfs";
        options = [ "soft" "timeo=50" "x-systemd.automount" "x-systemd.device-timeout=5s" "x-systemd.mount-timeout=5s"];
      };



}
