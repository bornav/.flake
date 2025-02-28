{ config, inputs, system, vars, lib, pkgs, ... }:
let
    # pkgs = import inputs.nixpkgs-unstable {
    #     config.allowUnfree = true;
    #     inherit system;
    # };
in
{
    home-manager.users.${vars.user} = {
        programs.alacritty = {
            enable = true;
            settings = {
                # https://github.com/tmcdonell/config-alacritty/blob/master/alacritty.yml
                window = {
                    dimensions = {
                        lines = 34;
                        columns = 89;
                    };
                    padding = {
                        x=0;
                        y=0;
                    };
                     # Available values:
                    # - full: borders and title bar
                    # - none: neither borders nor title bar
                    # - transparent: title bar, transparent background and title bar buttons
                    # - buttonless: title bar, transparent background, but no title bar buttons
                    decorations="transparent";
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
                scrolling.history = 50000;
                scrolling.multiplier = 7;
                # live_config_reload = false;
                # decorations = "None";
                font = { # TODO see how i like the font
                    # The normal (roman) font face to use.
                    # Style can be specified to pick a specific face.
                    
                    normal.family="Hack Nerd Font Mono";
                    normal.style="Regular";
                        # family: "Fira Code"
                        # family: "Source Code Pro"
                        # style: Retina

                    # The bold font face
                    bold.family="Hack Nerd Font Mono";
                    bold.style="Bold";
                        # family: "Fira Code"
                        # family: "Source Code Pro"

                    italic.family="Hack Nerd Font Mono";
                    italic.style="Italic";
                        # style: "Light Oblique"
                        # family: "Fira Code"
                        # family: "Source Code Pro"
                        # style: "Medium Italic"
                };
            };
        };
    };
}