{ config, inputs, vars, lib, ... }:
let
    pkgs = import inputs.nixpkgs-unstable {
        config.allowUnfree = true;
        system = "x86_64-linux";
    };
in
{
    home-manager.users.${vars.user} = {
        programs.alacritty = {
            enable = true;
            settings = {
                window.dimensions = {
                    lines = 34;
                    columns = 89;
                };
                # keyboard.bindings = [
                #     {
                #     key = "K";
                #     mods = "Control";
                #     chars = "\\x0c";
                #     }
                # ];
                # working_directory = "/home/bocmo";
                cursor.style.shape = "Beam";
                window.opacity = 0.8;
                live_config_reload = true;
                # decorations = "None";
                };
        };
    };
}