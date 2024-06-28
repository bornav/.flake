{ config, inputs, vars, lib, ... }:
let
    pkgs = import inputs.nixpkgs-unstable {
        config.allowUnfree = true;
        system = "x86_64-linux";
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
    };
    };
    config = lib.mkMerge [
    (lib.mkIf (config.virtualization.enable) {
        users.users.${vars.user}.extraGroups = [ "libvirtd" ];
        virtualisation.libvirtd.enable = true;
        programs.dconf.enable = true; # virt-manager requires dconf to remember settings
        environment.systemPackages = with pkgs; [ 
            virt-manager
            virt-viewer
            qemu
            spice
        ];
    })
    (lib.mkIf (config.virtualization.waydroid) {
        virtualisation.waydroid.enable = true;
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