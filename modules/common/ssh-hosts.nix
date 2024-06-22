
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
        IdentityFile /home/bocmo/.ssh/id_local
    Host k3s-local-01
        HostName k3s-local-01.local.icylair.com
        Port 22
        User root
        IdentitiesOnly yes
        StrictHostKeyChecking no
        IdentityFile /home/bocmo/.ssh/id_local
    Host vallium
        HostName vallium.local.icylair.com
        Port 22
        User bocmo
        IdentitiesOnly yes
        StrictHostKeyChecking no
        IdentityFile /home/bocmo/.ssh/id_local
    '';
}

