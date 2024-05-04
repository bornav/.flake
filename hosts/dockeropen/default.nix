{ config, pkgs, pkgs-unstable, vars, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.kernelPackages = pkgs-unstable.linuxKernel.packages.linux_6_8;
  boot.loader = {
    grub.efiSupport = true;
    grub.enable = true;
    grub.device = "nodev";
    efi.canTouchEfiVariables = true;
  };

  networking.hostName = "dockeropen"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };
  users.users.${vars.user} = {
    isNormalUser = true;
    description = "${vars.user}";
    extraGroups = [ "networkmanager" "wheel" "docker" "wireshark" ];
    packages = with pkgs; [];
  };
  environment.sessionVariables = {
    flake_name="dockeropen";
    FLAKE="$HOME/.flake";
    NIXOS_CONFIG="$HOME/.flake";
    # NIXOS_CONFIG="/home/${vars.user}/.flake";
    QT_STYLE_OVERRIDE="kvantum";
    WLR_NO_HARDWARE_CURSORS = "1"; # look into removing
    NIXOS_OZONE_WL = "1"; #Hint electron apps to use wayland
  };

  #### modules
  gnome.enable = false;
  cosmic-desktop.enable = false;
  virtualization.enable = true;
  devops.enable = false;
  steam.enable = false;
  virtualisation.docker.enable = true;
  rar.enable = true;
  thorium.enable = false;
  wg-home.enable = false;
  ai.enable = false;

  woothing.enable = false;
  finalmouse.enable = false;
  ####
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    jq
    gparted
    pciutils # lspci
  ];

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      # add any missing dynamic libraries for unpacked programs here, not in the environment.systemPackages
    ];
  };
}
