{ config, inputs, system, vars, lib, ... }:
let
    pkgs = import inputs.nixpkgs-unstable {
        config.allowUnfree = true;
        inherit system;
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
    Host dockeropen
        HostName dockeropen.nix.local
        Port 22
        User root
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
    Host k3s-local
        HostName k3s-local.local.icylair.com
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
    Host stealth
        HostName stealth.local.icylair.com
        Port 22
        User bocmo
        IdentitiesOnly yes
        StrictHostKeyChecking no
        IdentityFile /home/bocmo/.ssh/id_local
    Host holo
        HostName holo.local.icylair.com
        Port 22
        User root
        IdentitiesOnly yes
        StrictHostKeyChecking no
        IdentityFile /home/bocmo/.ssh/id_local
    Host proxmox
        HostName proxmox.local.icylair.com
        Port 22
        User root
        IdentitiesOnly yes
        StrictHostKeyChecking no
        IdentityFile /home/bocmo/.ssh/id_local
    Host oraclearm1
        HostName oraclearm1.cloud.icylair.com
        Port 22
        User root
        IdentitiesOnly yes
        StrictHostKeyChecking no
        IdentityFile /home/bocmo/.ssh/id_local
    Host oraclearm2
        HostName oraclearm2.cloud.icylair.com
        Port 22
        User root
        IdentitiesOnly yes
        StrictHostKeyChecking no
        IdentityFile /home/bocmo/.ssh/id_local
     Host k3s-oraclearm1
        HostName oraclearm1.cloud.icylair.com
        Port 22
        User root
        IdentitiesOnly yes
        StrictHostKeyChecking no
        IdentityFile /home/bocmo/.ssh/id_local
    Host k3s-oraclearm2
        HostName oraclearm2.cloud.icylair.com
        Port 22
        User root
        IdentitiesOnly yes
        StrictHostKeyChecking no
        IdentityFile /home/bocmo/.ssh/id_local
    '';
}

