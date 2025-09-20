{pkgs, lib, pkgs-unstable, ... }:

{
    programs.zed-editor = {
        enable = true;
        ## This populates the userSettings "auto_install_extensions"
        extensions = ["nix" "toml" "make" "catppuccin" "vscode-dark-modern"];
        userSettings = {
            features = {
              edit_prediction_provider = "none";
            };
            # assistant = {
            #     enabled = false;
            #     # version = "2";
            #     # default_open_ai_model = null;
            #     # ### PROVIDER OPTIONS
            #     # ### zed.dev models { claude-3-5-sonnet-latest } requires github connected
            #     # ### anthropic models { claude-3-5-sonnet-latest claude-3-haiku-latest claude-3-opus-latest  } requires API_KEY
            #     # ### copilot_chat models { gpt-4o gpt-4 gpt-3.5-turbo o1-preview } requires github connected
            #     # default_model = {
            #     #     provider = "zed.dev";
            #     #     model = "claude-3-5-sonnet-latest";
            #     # };
            # };

            node = {
                path = lib.getExe pkgs.nodejs;
                npm_path = lib.getExe' pkgs.nodejs "npm";
            };

            hour_format = "hour24";
            auto_update = false;
            terminal = {
                alternate_scroll = "off";
                blinking = "off";
                copy_on_select = false;
                dock = "bottom";
                detect_venv = {
                    on = {
                        directories = [".env" "env" ".venv" "venv"];
                        activate_script = "default";
                    };
                };
                env = {
                    TERM = "alacritty";
                };
                font_family = "Hack Nerd Font Mono";
                font_features = null;
                font_size = null;
                line_height = "standard";
                option_as_meta = false;
                button = false;
                shell = "system";
                #{
                #                    program = "zsh";
                #};
                # toolbar = { # this no longer exists
                #     title = true;
                # };
                working_directory = "current_project_directory";
            };



            lsp = {
                rust-analyzer = {
                    binary = {
                        #                        path = lib.getExe pkgs.rust-analyzer;
                        path_lookup = true;
                    };
                };
                nix = {
                    binary = {
                        path_lookup = true;
                    };
                };
            };

            format_on_save = "off";
            languages = {
              YAML = {
                # formatter = "prettier";
                # linter = "yamllint";
                tab_size = 2;
              };
              Nix = {
                tab_size = 2;
                language_servers = [ "nixd" "!nil" ];
              };

            };

            vim_mode = false;
            ## tell zed to use direnv and direnv can use a flake.nix enviroment.
            load_direnv = "shell_hook";
            base_keymap = "VSCode";
            theme = {
                mode = "system";
                light = "One Light";
                dark = "VSCode Dark Modern";
                # dark = "Catppuccin Macchiato - No Italics";
            };
            show_whitespaces = "all" ;
            ui_font_size = 16;
            buffer_font_size = 15;
        };

    };
    home.packages = [
        pkgs-unstable.nixd
        pkgs-unstable.nil
    ];
    home.file.".zed_server" = {
        source = "${pkgs.zed-editor.remote_server}/bin";
        # keeps the folder writable, but symlinks the binaries into it
        recursive = true;
      };

}
