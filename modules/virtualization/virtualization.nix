{ config, inputs, system, vars, lib, ... }:
let
    pkgs = import inputs.nixpkgs-unstable {
        config.allowUnfree = true;
        inherit system;
    };
in
# let
#   srcDir = "/home/${vars.user}/libvirt";  # Replace this with the path to your source directory
#   destDir = "/var/lib/libvirt";  # Replace this with the path to your destination directory
# in 
with lib;
{   
    options = {
    virtualization = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
      waydroid = mkOption {
        type = types.bool;
        default = false;
      };
      qemu = mkOption {
        type = types.bool;
        default = false;
      };
    };
    };
    config = lib.mkMerge [
    (lib.mkIf (config.virtualization.enable) {
      users.users.${vars.user}.extraGroups = [ "libvirtd" ]; # TODO, make this somehow conditional so that is there is no user it skips this
      virtualisation.libvirtd.enable = true;
      programs.dconf.enable = true; # virt-manager requires dconf to remember settings
      environment.systemPackages = with pkgs; [ 
          virt-manager
          virt-viewer
          qemu
          spice
          libgcc
      ];
      programs.appimage.binfmt = true;
      boot.binfmt.emulatedSystems = 
      [
        "aarch64-linux"
        # "x86_64-linux"
      ]; # TODO remove me, needed if i want to compile arm(which i do need infact)

    })
    (lib.mkIf (config.virtualization.waydroid) {
        virtualisation.waydroid.enable = true;
    })
    (lib.mkIf (config.virtualization.qemu) {
      virtualisation.libvirtd.qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [(pkgs.OVMF.override {
            secureBoot = true;
            tpmSupport = true;
          }).fd];
        };
      };
      })
    ];
    


    #look into 
    # boot.extraModprobeConfig = "options kvm_intel nested=1";
    ##
    
    # lib.symlinkJoin.name = "libvirt-dir";  # Name for your package
    # lib.symlinkJoin.isDir = true;  # Indicates that it's a directory link
    # lib.symlinkJoin.src = srcDir;  # Source directory
    # lib.symlinkJoin.dest = destDir;  # Destination directory
}
# {
#   description = "Flake to create a symlink between directories";

#   inputs = {};

#   outputs = { self, nixpkgs }: {
#     packages = {
#       myDirectoryLink = nixpkgs.lib.symlinkJoin {
#         name = "my-directory-link";  # Name for your package
#         isDir = true;  # Indicates that it's a directory link

#         src = "/path/to/source_directory";  # Replace with your source directory
#         dest = "/path/to/destination_directory";  # Replace with your destination directory
#       };
#     };
#   };
# }