{ config, lib, host, inputs, pkgs, pkgs-unstable, ... }:
# let
#   pkgs = import inputs.nixpkgs-unstable {
#     system = host.system;
#     config.allowUnfree = true;
#   };
#   pkgs-unstable = import inputs.nixpkgs-unstable {
#     system = host.system;
#     config.allowUnfree = true;
#   };
# in
{
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
