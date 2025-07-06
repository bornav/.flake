{inputs, config, pkgs, ... }:
{
# home.file."asdasd.sh".source = 
# let
#   script = pkgs.writeShellScriptBin "asdasd.sh" ''
#     asd
#   '';
# in
#   "${script}/bin/testscript.sh" ;

xdg.mime.enable = true;
xdg.mimeApps.enable = true;
## this may be neccesary sometimes
# xdg.configFile."mimeapps.list".force = true;
## from limited testing it is only applied if both sides are valid
xdg.mimeApps.defaultApplications = {
  "inode/directory" = "org.kde.dolphin.desktop";
};
home.file.".local/share/flatpak/overrides/global".text = ''
[Context]
filesystems=/run/current-system/sw/share/X11/fonts:ro;/nix/store:ro
'';
# home.packages = with pkgs; [
#   pika-backup
#   ];
}