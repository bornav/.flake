# [
# #   ./git.nix
#   ./dev/devops.nix # TODO
# #   ./direnv.nix
# ]
{
  imports = [
    ./common
    ./custom_pkg
    ./de
    ./dev
    ./devices
    ./gaming
    ./nix
    ./pkgs
    ./shell
    ./storage
    ./terminalEmulators
    ./utils
    ./virtualization
    ./vpn
  ];
}
