{ config, inputs, system, host, vars, lib, pkgs, ... }:
{
#   home-manager.users.${vars.user} = {
    home.file.".config/klipperrc".text = ''
    [General]
    IgnoreImages=false
    MaxClipItems=1000
    Version=6.4.4
    '';
#   };
}
