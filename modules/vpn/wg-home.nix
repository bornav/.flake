{ config, system, lib, ... }:
with lib;
{   
  options = {
    wg-home = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
      local_ip = mkOption {
        type = types.string;
        default = "10.10.1.0/24";
      };
    };
  };
  config = mkIf (config.wg-home.enable) {
    networking.wg-quick.interfaces = {
      wg9 = {
        address = [ config.wg-home.local_ip ];
        dns = [ "10.10.1.1" ];
        privateKeyFile = "/home/bocmo/.ssh/wg/priv.key";
        peers = [
          {
            publicKey = "ijU4YxKoxbBwGZBIxuo8SXYtd9mU3Fug77ZdpM+0OUo=";
            allowedIPs = [ "10.0.0.0/8"];
            endpoint = "home.local.icylair.com:51820";
            persistentKeepalive = 25;
          }
        ];
      };
      
    };
  #   networking.wireguard.enable = true;
  #   networking.wireguard.interfaces = {
  #     wg0 = {
  #       ips = [ config.wg-home.local_ip ];
  #       listenPort = 51820;
  #       privateKeyFile = "/home/bocmo/.ssh/wg/priv.key";
  #       peers = [
  #         {
  #           publicKey = "ijU4YxKoxbBwGZBIxuo8SXYtd9mU3Fug77ZdpM+0OUo=";
  #           allowedIPs = [ "10.0.0.0/8"];
  #           endpoint = "home.local.icylair.com:51820";
  #           persistentKeepalive = 25;
  #         }
  #       ];
  #     };
  #   };
  };
}