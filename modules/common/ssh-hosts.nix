
{ config, inputs, vars, lib, ... }:
let
    pkgs = import inputs.nixpkgs-unstable {
        config.allowUnfree = true;
        system = "x86_64-linux";
    };
in
{
  programs.ssh.extraConfig = ''
  Host nixbuilder_dockeropen
    HostName builder1.nix.local.icylair.com
    Port 22
    User nixbuilder
    IdentitiesOnly yes
    StrictHostKeyChecking no
    IdentityFile ~/.ssh/id_local
'';
}

