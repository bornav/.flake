{ config, inputs, system, vars, lib, ... }:
let
    pkgs = import inputs.nixpkgs-stable {
        config.allowUnfree = true;
        inherit system;
    };
in

with lib;
{
  options = {
    flatpak = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config = mkIf (config.flatpak.enable) {
    services.flatpak.enable = true;
    systemd.services.flatpak-repo = {
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.flatpak ];
      script = ''
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      '';
    };
    services.flatpak.packages = [
      # { appId = "com.brave.Browser"; origin = "flathub";  }
      # "com.obsproject.Studio"
      # "im.riot.Riot"
      "com.github.tchx84.Flatseal"
      # "app/org.kicad.KiCad/x86_64/stable"
      "it.mijorus.gearlever"
      # "app/com.usebottles.bottles/x86_64/stable"
    ];
    # services.flatpak.update.auto = {
    #   enable = false;
    #   onCalendar = "daily"; # Default value
    # };
    ##
  };
}