{ config, pkgs, ... }:

{
  imports =
    [ ./hardware-configuration.nix];
  boot.loader = {
    #systemd-boot.enable = true;
    grub.efiSupport = true;
    grub.enable = true;
    grub.device = "nodev";
    #efi.efiSysMountPoint = "/boot/EFI";
    efi.canTouchEfiVariables = true;
    #grub.useOSProber = true;
    grub.extraEntries = ''
        menuentry 'Windows Boot Manager (on /dev/nvme0n1p1)' --class windows --class os $menuentry_id_option 'windows' {
                savedefault
                insmod part_gpt
                insmod fat
                search --no-floppy --label BOOT
                chainloader /EFI/Microsoft/Boot/bootmgfw.efi
        }
          menuentry 'Arch Linux, with Linux linux' --class arch --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-linux-advanced-109c9c71-abfc-46d9-b983-9dd681b53ce4' {
            savedefault
                        load_video
                        set gfxpayload=keep
                        insmod gzio
                        insmod part_gpt
                        insmod fat
                        search --no-floppy --label GRUB
                        echo    'Loading Linux linux ...'
                        linux   /vmlinuz-linux root=LABEL=root_partition rw  loglevel=3 nvidia-drm.modeset=1 iommu=pt
                        echo    'Loading initial ramdisk ...'
                        initrd  /amd-ucode.img /initramfs-linux.img
        }
    '';
  };
  networking.hostName = "vallium"; # Define your hostname.

  networking.networkmanager.enable = true;
 
  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  users.users.bocmo = {
    isNormalUser = true;
    description = "bocmo";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [];
  };

  nixpkgs.config.allowUnfree = true;
  ###################################################
  #gnome part
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
  ]) ++ (with pkgs.gnome; [
    cheese # webcam tool
    gnome-music
    gnome-terminal
    gedit # text editor
    epiphany # web browser
    geary # email reader
    evince # document viewer
    gnome-characters
    totem # video player
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
  ]);
  #####################################################
  environment.systemPackages = with pkgs; [
    alacritty
    #firefox
  ];

 programs.gnupg.agent = {
   enable = true;
   enableSSHSupport = true;
 };

  virtualisation.docker.enable = true;

  services.flatpak.enable = true;
  services.openssh.enable = true;
  services.sshd.enable = true;

  hardware.opengl = {
	enable = true;
	#dirSupport = true;
	#dirSupport32Bit = true;
  };
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
	modesetting.enable = true;

	powerManagement.enable = true;
	powerManagement.finegrained = false;
	open = false;
	nvidiaSettings = true;
	package = config.boot.kernelPackages.nvidiaPackages.stable;
	};


}

