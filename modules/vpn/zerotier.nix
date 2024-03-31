{ config, pkgs, pkgs-unstable, vars, lib, ... }:
{   #zerotier-one -d run this to enable the svc
    environment.systemPackages = with pkgs; [ 
        zerotierone
    ];
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