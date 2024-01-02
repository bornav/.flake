#
#  Git
#

{ config, lib, pkgs, vars, ... }:
{
    home-manager.users.${vars.user} = {
        programs.alacritty = {
            enable = true;
        };
    };
}