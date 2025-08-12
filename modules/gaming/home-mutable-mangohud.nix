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
home.file.".config/MangoHud/MangoHud.conf" = {
  text = ''
    # alpha=0.7
    gpu_power
    gpu_temp
    display_server
    # histogram
    horizontal
    hud_compact
    hud_no_margin
    no_display # hide by default. Rshift+f12
    '';
  force = true;
  mutable = true;
  };
}