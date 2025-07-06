# this file depends on mutability.nix file to be imported from home-manager user level, it adds force and mutable fields
{inputs, config, pkgs, ... }:
{
# imports = [
#     import ../mutability.nix
#     # possibly other imports
#   ];
# home.file."asdasd.sh".source = 
# let
#   script = pkgs.writeShellScriptBin "asdasd.sh" ''
#     asd
#   '';
# in
#   "${script}/bin/testscript.sh" ;
home.file.".local/share/flatpak/overrides/global2" = {
  text = ''
    [Context]
    filesystems=/run/current-system/sw/share/X11/fonts:ro;/nix/store:ro
    '';
  force = true;
  mutable = true;
  };
}