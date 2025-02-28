{ config, inputs, system, vars, lib, pkgs, ... }:
# let
#     pkgs = import inputs.nixpkgs-unstable {
#         config.allowUnfree = true;
#         inherit system;
#     };
# in
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