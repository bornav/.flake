#
#  Git
#

{ config, lib, pkgs, vars, ... }:
{
    home-manager.users.${vars.user} = {
        home.packages = [ pkgs.git-lfs ];
        programs.git = {
            package = pkgs.gitAndTools.gitFull;
            enable = true;
            userName  = "bornav";
            userEmail = "borna.vincek1@gmail.com";
        };
    };
}