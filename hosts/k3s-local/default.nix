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
  imports = [
    inputs.home-manager.nixosModules.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;}
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.nix-flatpak.nixosModules.nix-flatpak
    inputs.disko.nixosModules.disko
    ./hardware-configuration.nix
    ./disk-config.nix
    ./k3s-server.nix
    {_module.args.disks = [ "/dev/sda" ];}
  ];

  # boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.kernelPackages = pkgs-unstable.linuxKernel.packages.linux_6_8;
  boot.loader = {
    grub.enable = true;
    grub.device = "nodev";
    # efi.canTouchEfiVariables = true;
    # grub.efiInstallAsRemovable = lib.mkForce false;
    grub.efiSupport = true;
    grub.efiInstallAsRemovable = lib.mkForce true;
  };

  networking.hostName = "k3s-local"; # Define your hostname.
  networking.networkmanager.enable = true;
  programs.nh.enable = true;
  services = {
    openssh = {                             # SSH
      enable = true;
      allowSFTP = true;                     # SFTP
      extraConfig = ''
        HostKeyAlgorithms +ssh-rsa
      '';
    };
    xserver = {
      xkb.layout = "us";
      xkb.variant = "";
    };
  };
  users.users.root.openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEGiVyNsVCk2KAGfCGosJUFig6PyCUwCaEp08p/0IDI7"];
  users.users.root.initialPassword = "nixos";
  users.users.${vars.user} = {
    isNormalUser = true;
    initialPassword = "nixos";
    description = "${vars.user}";
    extraGroups = [ "networkmanager" "wheel" "docker"];
    # packages = with pkgs; [];
    openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEGiVyNsVCk2KAGfCGosJUFig6PyCUwCaEp08p/0IDI7"];
  };
  time.timeZone = "Europe/Vienna";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "de_AT.UTF-8";
      LC_IDENTIFICATION = "de_AT.UTF-8";
      LC_MEASUREMENT = "de_AT.UTF-8";
      LC_MONETARY = "de_AT.UTF-8";
      LC_NAME = "de_AT.UTF-8";
      LC_NUMERIC = "de_AT.UTF-8";
      LC_PAPER = "de_AT.UTF-8";
      LC_TELEPHONE = "de_AT.UTF-8";
      LC_TIME = "de_AT.UTF-8";
    };
  };
  environment.sessionVariables = {
    flake_name="k3s-local";
    FLAKE="$HOME/.flake";
    NIXOS_CONFIG="$HOME/.flake";
    # NIXOS_CONFIG="/home/${vars.user}/.flake";
  };

  ####
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    jq
    gparted
    pciutils # lspci
  ];

  programs.nix-ld.enable = true;
  system = {                                # NixOS Settings
    # autoUpgrade = {                        # Allow Auto Update (not useful in flakes)
    #  enable = true;
    #  flake = inputs.self.outPath;
    #  flags = [
    #    "--update-input"
    #    "nixpkgs"
    #    "-L"
    #  ];
    # };
    stateVersion = "${vars.stateVersion}";
  };
  systemd.extraConfig = ''
    DefaultTimeoutStopSec=20s
  ''; # sets the systemd stopjob timeout to somethng else than 90 seconds
  nix = {
    settings.auto-optimise-store = true;
    gc = {                                  # Garbage Collection
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
    settings.max-jobs = 4;
  };
}
