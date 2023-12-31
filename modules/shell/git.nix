#
#  Git
#

{ config, lib, pkgs, vars, ... }:
with lib;
{
    home.packages = with pkgs;[
    git 
    ];

    programs.git = {
        package = pkgs.gitAndTools.gitFull;
        enable = true;
        userName  = "my_git_username";
        userEmail = "my_git_username@gmail.com";
    };
}