{ config, lib, host, inputs, pkgs, pkgs-master, ... }:
# let
#   pkgs = import inputs.nixpkgs-unstable {
#     system = host.system;
#     config.allowUnfree = true;
#   };
#   pkgs-master = import inputs.nixpkgs-master {
#     system = host.system;
#     config.allowUnfree = true;
#   };
# in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
    }
    inputs.nixos-cosmic.nixosModules.default
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.nix-flatpak.nixosModules.nix-flatpak
    inputs.disko.nixosModules.disko
    ./hardware-configuration.nix
    ./nvidia.nix
    # ./journald-gateway.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.kernelPackages = pkgs-master.linuxPackages_testing;
  # boot.kernelPackages = pkgs-unstable.linuxKernel.packages.linux_6_8;
  boot.loader = {
    timeout = 1;
    grub.efiSupport = true;
    grub.enable = true;
    grub.device = "nodev";
    efi.canTouchEfiVariables = true;
    grub.efiInstallAsRemovable = lib.mkForce false;
  };
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
  networking.hostName = host.hostName; # Define your hostname.
  networking.networkmanager.enable = true;

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  # mdns
  services.avahi = {
    nssmdns4 = true;
    enable = true;
    ipv4 = true;
    ipv6 = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
  };
  #

  users.users.root.openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEGiVyNsVCk2KAGfCGosJUFig6PyCUwCaEp08p/0IDI7"];
  users.users.root.initialPassword = "nixos";
  users.users.${host.vars.user} = {
    isNormalUser = true;
    description = "${host.vars.user}";
    extraGroups = [ "networkmanager" "wheel" "docker"];
    # packages = with pkgs; [];
    openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEGiVyNsVCk2KAGfCGosJUFig6PyCUwCaEp08p/0IDI7"];
  };
  environment.sessionVariables = {
    flake_name=host.hostName;
    FLAKE="$HOME/.flake";
    NIXOS_CONFIG="$HOME/.flake";
    # NIXOS_CONFIG="/home/${host.vars.user}/.flake";
  };
  #### modules
  virtualization.enable = true;
  devops.enable = true;
  rar.enable = true;
  docker.enable = true;
  builder.builder1.self = true;
  # builder.builder1.remote = true;
  # portainer.enable = false;
  ####
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    jq
    gparted
    btop
    pciutils # lspci
  ];
  services.qemuGuest.enable = true;
  programs.nix-ld = {
    enable = true;
    # libraries = with pkgs; [
    #   # add any missing dynamic libraries for unpacked programs here, not in the environment.systemPackages
    # ];
  };
  virtualisation.docker.logDriver = lib.mkForce "json-file";
  virtualisation.docker.daemon.settings = {
    "exec-opts" = ["native.cgroupdriver=cgroupfs"];
    "log-opts" = {
      "max-size" = "10m";
      # "tag" = "docker.{{.Name}}";
      "tag" = "local-{{.Name}}|{{.ImageName}}|{{.ID}}";
      
      "labels" = "com.docker.compose.project";
      "env" = "os,customer";
    };
  };
  services.journald = {
    extraConfig = ''
      SystemMaxUse=50M      # Maximum disk usage for the entire journal
      SystemMaxFileSize=50M # Maximum size for individual journal files
      RuntimeMaxUse=50M     # Maximum disk usage for runtime journal
      MaxRetentionSec=1month # How long to keep journal files
    '';
  };



  ### iscsi
  services.openiscsi = {
    enable = true;
    discoverPortal = [ "10.2.11.200:3260" ];
    name = lib.mkForce "iqn.2005-10.org.freenas.ctl:iscsi-dockeropen";
  };
  systemd.services.iscsi-login-lingames = {
    description = "Login to iSCSI target iqn.2005-10.org.freenas.ctl:iscsi-dockeropen";
    after = [ "network.target" "iscsid.service" ];
    wants = [ "iscsid.service" ];
    serviceConfig = {
      ExecStartPre = "${pkgs.openiscsi}/bin/iscsiadm -m discovery -t sendtargets -p 10.2.11.200";
      ExecStart = "${pkgs.openiscsi}/bin/iscsiadm -m node -T iqn.2005-10.org.freenas.ctl:iscsi-dockeropen -p 10.2.11.200 --login";
      ExecStop = "${pkgs.openiscsi}/bin/iscsiadm -m node -T iqn.2005-10.org.freenas.ctl:iscsi-dockeropen -p 10.2.11.200 --logout";
      Restart = "on-failure";
      RemainAfterExit = true;
    };
    wantedBy = [ "multi-user.target" ];
  };
  #diskmount 
  fileSystems."/docker" = {
    device = "/dev/disk/by-id/scsi-36589cfc00000015adab2e4fe3f5ed2ce-part1";
    fsType = "ext4";
    options = ["defaults" "_netdev" "noatime"];
  };
  ### iscsi

}
