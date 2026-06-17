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
  ./gnome.nix
  ./plasma.nix
  ./hyprland.nix
#   ./direnv.nix
  ];
}
