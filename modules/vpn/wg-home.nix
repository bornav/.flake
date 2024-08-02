{ config, system, lib, ... }:
with lib;
{   
    options = {
      wg-home = {
        enable = mkOption {
          type = types.bool;
          default = false;
        };
      };
    };
    config = mkIf (config.wg-home.enable) {
      networking.wg-quick.interfaces = {
        wg9 = {
          address = [ "10.10.1.0/24" ];
          dns = [ "10.1.1.1" ];
          privateKeyFile = "/home/bocmo/.ssh/wg/priv.key";
          
          peers = [
            {
              publicKey = "ijU4YxKoxbBwGZBIxuo8SXYtd9mU3Fug77ZdpM+0OUo=";
              allowedIPs = [ "10.0.0.0/0"];
              endpoint = "home.local.icylair.com:51820";
              persistentKeepalive = 25;
            }
          ];
        };
      };
    };
}
# nmcli connection import type wireguard file wg0.conf to add connection to the gui
# wg.conf example
# [Interface]
# Address = 10.10.1.0/24
# DNS = 10.1.1.5
# ListenPort = 51820
# PrivateKey = x

# [Peer]
# AllowedIPs = 10.0.0.0/8
# Endpoint = home.local.icylair.com:51820
# PublicKey = x