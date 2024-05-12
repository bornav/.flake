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
    # grub.efiInstallAsRemovable = false;
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
    extraGroups = [ "networkmanager" "wheel" "docker"];
    packages = with pkgs; [];
    openssh.authorizedKeys.keys = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDeIvrOE9lMNjGuW6pm0RMGET8ze+Qr9/R4fgXplguadgOPi1rys3mRXkxMLMPgLbKrSRACt33arRprfnSbA6YIMl6WdaOSJAh0uPHeD82tt90F2DuQKCqCLmjbQenaFrjBlTlKnSpRTZd0m+5nfHOSE4XCyIllULhBKh6wrNdulJ3X7ZrpqS3gS/P5R7jxghScjUR/Y+GmhuLroow85LgzGQuoDfanm6YQgTB9Y+vYzUIZWs6edAEkGesTUJdnAxUIrEssBZUiWfw/ZqwK+APiQ0cCjcr8PR4wHMo0gK2Xgspn6FoIpogQBCJreQ2gColot9uYZaE6qla3JtAP3qlcjstkbh0qploijz0AMLLM8njs6hK5XSnjLsvc68q1OfS8NREWCs2z7m7ZR3UbeKcl1P3UkPsbCnqTFao618ISb2ButR5yFROqmKdk4fcQajdlKRtvgMc6zC0OI5ApyLCCIhPwGDrTjMl1rrAL7O1/aV8jg2X1Efqg1g1UV3qsmnSNUUO30W0EMI63KlynOF9uSpuBTc5we2OIK2hOF6ty5wpb3Y6a+vNnEl8A4QqvhTA0DZB4miH1PGweAc5P1mrNHcmj3oBGh3FxkxH8dpltkP5lckIHcRHZEKdLrQN0y54aoE9mfm08q3StmS0PDFI1LhUaH7wIxCApMLl+TYIFFw=="];
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
  devops.enable = true;
  steam.enable = false;
  rar.enable = true;
  thorium.enable = false;
  wg-home.enable = false;
  ai.enable = false;
  builder.enable = true;
  portainer.enable = true;

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
