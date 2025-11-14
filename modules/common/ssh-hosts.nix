{ config, inputs, system, vars, lib, pkgs, ... }:
# let
#     pkgs = import inputs.nixpkgs-unstable {
#         config.allowUnfree = true;
#         inherit system;
#     };
# in
{
  programs.ssh.extraConfig = ''
    Host nixbuilder_dockeropen
        HostName builder1.nix.local.icylair.com
        Port 22
        User nixbuilder
        IdentitiesOnly yes
        StrictHostKeyChecking no
        IdentityFile /home/user/.ssh/id_local
    Host dockeropen
        HostName dockeropen.nix.local
        Port 22
        User root
        IdentitiesOnly yes
        StrictHostKeyChecking no
        IdentityFile /home/user/.ssh/id_local
    Host k3s-local-01
        HostName k3s-local-01.local.icylair.com
        Port 22
        User root
        IdentitiesOnly yes
        StrictHostKeyChecking no
        IdentityFile /home/user/.ssh/id_local
    Host k3s-local-02
        HostName k3s-local-02.local.icylair.com
        Port 22
        User root
        IdentitiesOnly yes
        StrictHostKeyChecking no
        IdentityFile /home/user/.ssh/id_local
    Host k3s-local
        HostName k3s-local.local.icylair.com
        Port 22
        User root
        IdentitiesOnly yes
        StrictHostKeyChecking no
        IdentityFile /home/user/.ssh/id_local
    Host vallium
        HostName vallium.local.icylair.com
        Port 22
        User user
        IdentitiesOnly yes
        StrictHostKeyChecking no
        IdentityFile /home/user/.ssh/id_local
    Host zbook-max395
        HostName zbook-max395.local
        Port 22
        User user
        IdentitiesOnly yes
        StrictHostKeyChecking no
        IdentityFile /home/user/.ssh/id_local
    Host stealth
        HostName stealth.local.icylair.com
        Port 22
        User user
        IdentitiesOnly yes
        StrictHostKeyChecking no
        IdentityFile /home/user/.ssh/id_local
    Host holo
        HostName holo.local.icylair.com
        Port 22
        User root
        IdentitiesOnly yes
        StrictHostKeyChecking no
        IdentityFile /home/user/.ssh/id_local
    Host proxmox
        HostName proxmox.local.icylair.com
        Port 22
        User root
        IdentitiesOnly yes
        StrictHostKeyChecking no
        IdentityFile /home/user/.ssh/id_local
    Host oracle-bv1-1
        HostName oracle-bv1-1.cloud.icylair.com
        Port 22
        User root
        IdentitiesOnly yes
        StrictHostKeyChecking no
        IdentityFile /home/user/.ssh/id_local
    Host oracle-km1-1
        HostName oracle-km1-1.cloud.icylair.com
        Port 22
        User root
        IdentitiesOnly yes
        StrictHostKeyChecking no
        IdentityFile /home/user/.ssh/id_local
    Host oracle-x86-03
        HostName oracle3.cloud.icylair.com
        Port 22
        User root
        IdentitiesOnly yes
        StrictHostKeyChecking no
        IdentityFile /home/user/.ssh/id_local
    Host contabo-1
        HostName contabo-1.cloud.icylair.com
        Port 22
        User root
        IdentitiesOnly yes
        StrictHostKeyChecking no
        IdentityFile /home/user/.ssh/id_local
    Host hetzner-01
        HostName hetzner-4gb-nbg1-6-01.cloud.icylair.com
        Port 22
        User root
        IdentitiesOnly yes
        StrictHostKeyChecking no
        IdentityFile /home/user/.ssh/id_local
    Host switch
        HostName 10.0.0.250
        User admin
        HostKeyAlgorithms +ssh-rsa
        PubkeyAcceptedAlgorithms +ssh-rsa
        Ciphers aes256-cbc,aes128-cbc,3des-cbc
    Host qemu-ubuntu-24-lts
        HostName 192.168.124.129
        User root
        IdentityFile /home/bornav/.ssh/pw-less_vm_access_rsa
        RequestTTY yes
        RemoteCommand tmux new -A -s ssh-remote-session
        #Match exec "[[ -z '$SSH_TTY' ]"
        ##    RemoteCommand none
    Host printer_old
        HostName mainsailos.local
        Port 22
        User root
        IdentitiesOnly yes
        StrictHostKeyChecking no
        IdentityFile /home/user/.ssh/id_local
    Host printer_new
        HostName cm4klipper.local
        Port 22
        User root
        IdentitiesOnly yes
        StrictHostKeyChecking no
        IdentityFile /home/user/.ssh/id_local
    Host lighthouse
        HostName 159.69.206.117
        # HostName 2a01:4f8:c012:c800::1
        Port 22
        User root
        IdentitiesOnly yes
        StrictHostKeyChecking no
        # IdentityFile /home/user/.ssh/cdn_key_pwless
        IdentityFile /home/user/.ssh/id_local
    Host lighthouse2
        HostName 91.99.76.94
        # HostName 2a01:4f8:c012:c800::1
        Port 22
        User root
        IdentitiesOnly yes
        StrictHostKeyChecking no
        # IdentityFile /home/user/.ssh/cdn_key_pwless
        IdentityFile /home/user/.ssh/id_local
    Host rke2-local-example
        HostName rke2-local-example.local.icylair.com
        # HostName 2a01:4f8:c012:c800::1
        Port 22
        User root
        IdentitiesOnly yes
        StrictHostKeyChecking no
        # IdentityFile /home/user/.ssh/cdn_key_pwless
        IdentityFile /home/user/.ssh/id_local
    Host rke2-local-cp-01
        HostName rke2-local-cp-01.local.icylair.com
        # HostName 2a01:4f8:c012:c800::1
        Port 22
        User root
        IdentitiesOnly yes
        StrictHostKeyChecking no
        # IdentityFile /home/user/.ssh/cdn_key_pwless
        IdentityFile /home/user/.ssh/id_local
    Host rke2-local-node-01
        HostName rke2-local-node-01.local.icylair.com
        # HostName 2a01:4f8:c012:c800::1
        Port 22
        User root
        IdentitiesOnly yes
        StrictHostKeyChecking no
        # IdentityFile /home/user/.ssh/cdn_key_pwless
        IdentityFile /home/user/.ssh/id_local

    Host rke2-local-node-02
        HostName rke2-local-node-02.local.icylair.com
        # HostName 2a01:4f8:c012:c800::1
        Port 22
        User root
        IdentitiesOnly yes
        StrictHostKeyChecking no
        # IdentityFile /home/user/.ssh/cdn_key_pwless
        IdentityFile /home/user/.ssh/id_local
    Host git
        HostName git.local
        # HostName 2a01:4f8:c012:c800::1
        Port 22
        User root
        IdentitiesOnly yes
        StrictHostKeyChecking no
        # IdentityFile /home/user/.ssh/cdn_key_pwless
        IdentityFile /home/user/.ssh/id_local
    '';
}
