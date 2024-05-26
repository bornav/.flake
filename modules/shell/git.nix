{ config, inputs, vars, lib, ... }:
let
    pkgs = import inputs.nixpkgs-unstable {
        config.allowUnfree = true;
        system = "x86_64-linux";
    };
in
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