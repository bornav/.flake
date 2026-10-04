{
  config,
  inputs,
  system,
  vars,
  lib,
  pkgs,
  ...
}:
# let
#     pkgs = import inputs.nixpkgs-unstable {
#         config.allowUnfree = true;
#         inherit system;
#     };
# in
# let
#   srcDir = "/home/${vars.user}/libvirt";  # Replace this with the path to your source directory
#   destDir = "/var/lib/libvirt";  # Replace this with the path to your destination directory
# in
with lib; {
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
      users.users.${vars.user}.extraGroups = ["libvirtd" "kvm"]; # TODO, make this somehow conditional so that is there is no user it skips this
      programs.dconf.enable = true; # virt-manager requires dconf to remember settings
      environment.systemPackages = with pkgs; [
        virt-manager
        virt-viewer
        qemu
        spice
        libgcc
        dnsmasq
        dmidecode
      ];
      programs.appimage.binfmt = true;
      boot.binfmt.emulatedSystems = [
        "aarch64-linux"
        # "x86_64-linux"
      ]; # TODO remove me, needed if i want to compile arm(which i do need infact)
    })
    (lib.mkIf (config.virtualization.waydroid) {
      virtualisation.waydroid.enable = true;
    })
    (lib.mkIf (config.virtualization.qemu) {
      programs.virt-manager.enable = true;
      virtualisation.libvirtd.enable = true;
      virtualisation.libvirtd.qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        # ovmf = { # TODO look for alternative
        #   enable = true;
        #   packages = [(pkgs.OVMF.override {
        #     secureBoot = true;
        #     tpmSupport = true;
        #   }).fd];
        # };
        verbatimConfig =
          ''
            namespaces = []
            cgroup_device_acl = [
                "/dev/null", "/dev/full", "/dev/zero",
                "/dev/random", "/dev/urandom", "/dev/ptmx",
                "/dev/kvm", "/dev/kqemu", "/dev/rtc", "/dev/hpet",
                "/dev/net/tun",
                "/dev/kvmfr0"
            ]
          '';
      };
    })
  ];
}
