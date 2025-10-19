#
#  Shell
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ configuration.nix
#   └─ ./modules
#       └─ ./shell
#           ├─ default.nix *
#           └─ ...
#

{
  imports = [
#   ./git.nix
  ./rar.nix
  ./ssh-hosts.nix
  ./flatpak.nix
  ./lazygit.nix
#   ./direnv.nix
  ];
}
