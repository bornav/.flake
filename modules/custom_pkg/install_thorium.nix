{ config, inputs, system, vars, lib, pkgs, ... }:
# let
#     pkgs = import inputs.nixpkgs-unstable {
#         config.allowUnfree = true;
#         inherit system;
#     };
# in
with lib;
let
    # note to check if valid, make sure otherl like middleclickscroll work, on one being bad all features will stop working
    # https://github.com/Alex313031/thorium/blob/9bdeac89dd5cebe7120c063942ce0842dea40dec/infra/CMDLINE_FLAGS_LIST.md?plain=1#L1054 location of all flags
    ## seems this stopped working, investigate why
    # thorium-flags_dot_conf = ''
    #     --enable-blink-features=MiddleClickAutoscroll 
    #     --enable-features=VaapiOnNvidiaGPUs
    #     --gtk-version=4 
    #     --custom-ntp=https://dashboard.icylair.com
    #     --enable-features=UseOzonePlatform 
    #     --ozone-platform-hint=auto 
    # '';
        # --ozone-platform=wayland
    thorium-flags_dot_conf = ''--enable-blink-features=MiddleClickAutoscroll --enable-features=VaapiOnNvidiaGPUs --gtk-version=4 --custom-ntp=https://dashboard.icylair.com --enable-features=UseOzonePlatform --ozone-platform-hint=auto'';
in
{
  options = {
    thorium = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config = mkIf (config.thorium.enable) {
    environment = {
        systemPackages = with pkgs; [
            (pkgs.callPackage ./thorium2.nix {commandLineArgs = thorium-flags_dot_conf;})
        ];}; #$XDG_CONFIG_HOME
    home-manager.users.${vars.user} = {
        # xdg.configFile = {
        #     "thorium-flags.conf" = {
        #         enable = true;
        #         text = thorium-flags_dot_conf;
        #     };
        #     # "thorium-browser.sh" = {
        #     #     enable = true;
        #     #     text = thorium-exec;
        #     # };
        # };
        xdg.mimeApps.defaultApplications."text/html" = "thorium-browser.desktop";
        xdg.mimeApps.defaultApplications = {
            "text/xml" = [ "thorium-browser.desktop" ];
            "x-scheme-handler/http" = [ "thorium-browser.desktop" ];
            "x-scheme-handler/https" = [ "thorium-browser.desktop" ];
        };
        # xdg.desktopEntries = {
        #     tttt = {
        #         name = "tttt";
        #         genericName = "Web Browser";
        #         exec = "/home/bocmo/.config/thorium-browser.sh";
        #         # exec = "thorium";
        #         terminal = false;
        #         categories = [ "Application" "Network" "WebBrowser" ];
        #         mimeType = [ "text/html" "text/xml" ];
        #     };
        # };
    };
  };
}
    