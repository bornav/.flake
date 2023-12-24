{ config, pkgs, pkgs-unstable, vars, lib, ... }:
{
    environment.systemPackages = with pkgs; [ 
        zerotierone
    ];
}