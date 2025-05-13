{ disks ? [ "/dev/vdb" ], ... }: 
# { lib, ... }:
{
 disko.devices = {
  disk.disk1 = {
    # device = builtins.elemAt disks 0;
    device = "/dev/nvme0n1";
    type = "disk";
    content = {
     type = "gpt";
     partitions = {
      BOOT = {
        name = "ESP";
        size = "500M";
        type = "EF00";
        content = {
          type = "filesystem";
          format = "vfat";
          mountpoint = "/boot";
        };
      };
      home = {
        name = "home";
        size = "2048G";
        content = {
          type = "filesystem";
          format = "ext4";
          mountpoint = "/home";
        };
      };
      root = {
        name = "root";
        size = "512G";
        content = {
          type = "filesystem";
          format = "ext4";
          mountpoint = "/";
        };
      };
      ubuntu = {
        name = "ubuntu";
        size = "256G";
      };
     };
    };
   };
  };
}