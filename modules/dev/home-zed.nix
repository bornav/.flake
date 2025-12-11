{
  lib,
  pkgs,
  ...
}:

{
  programs.zed-editor = {
    enable = true;
    ## This populates the userSettings "auto_install_extensions"
    extensions = [
      "nix"
      "toml"
      "make"
      "catppuccin"
      "vscode-dark-modern"
    ];
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
        copy_on_select = true;
        dock = "bottom";
        detect_venv = {
          on = {
            directories = [
              ".env"
              "env"
              ".venv"
              "venv"
            ];
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
      global_lsp_settings = {
        button = true;
      };
      lsp = {
        rust-analyzer = {
          binary = {
            path = lib.getExe pkgs.rust-analyzer;
            # path_lookup = true;
          };
        };
        nix = {
          binary = {
            path = lib.getExe pkgs.nixd;
            # path_lookup = true;
          };
        };
      };

      format_on_save = "off";
      languages = {
        YAML = {
          # formatter = "prettier";
          # linter = "yamllint";
          colorize_brackets = true;
          tab_size = 2;
        };
        Nix = {
          tab_size = 2;
          colorize_brackets = true;
          language_servers = [
            "nixd"
            "!nil"
          ];
          formatter = {
            external = {
              command = "alejandra";
              arguments = ["--quiet"];
            };
          };
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
      show_whitespaces = "all";
      ui_font_size = 16;
      buffer_font_size = 15;
      gutter = {
        line_numbers = true; # Show/hide line numbers in the gutter.
        runnables = true; # Show/hide runnables buttons in the gutter.
        breakpoints = true; # Show/hide show breakpoints in the gutter.
        folds = true; # Show/hide show fold buttons in the gutter.
        min_line_number_digits = 1; # Reserve space for N digit line numbers
      };
      relative_line_numbers = "disabled"; # Show relative line numbers in gutter

      git = {
        inline_blame = {
          enabled = true; # Show/hide inline blame
          delay_ms = 0; # Show after delay (ms)
          min_column = 60; # Minimum column to inline display blame
          padding = 4; # Padding between code and inline blame (em)
          show_commit_summary = true; # Show/hide commit summary
        };
        hunk_style = "staged_hollow"; # staged_hollow, unstaged_hollow
      };

      toolbar = {
        breadcrumbs = true; # Whether to show breadcrumbs.
        quick_actions = true; # Whether to show quick action buttons.
        selections_menu = true; # Whether to show the Selections menu
        agent_review = true; # Whether to show agent review buttons
        code_actions = true; # Whether to show code action buttons
      };

      minimap = {
        show = "never";
      };

      vertical_scroll_margin = 3; # Lines to keep above/below the cursor when scrolling with the keyboard
      scroll_beyond_last_line = "vertical_scroll_margin"; # Control Editor scroll beyond the last line: off, one_page, vertical_scroll_margin
      tabs = {
        git_status = true; # Color to show git status
        close_position = "right"; # Close button position (left, right, hidden)
        show_close_button = "hover"; # Close button shown (hover, always, hidden)
        file_icons = true; # Icon showing file type
        show_diagnostics = "all"; # Show diagnostics in file icon (off, errors, all). Requires file_icons=true
      };

      ## TODO impo test every impo
      snippet_sort_order = "inline"; # Snippets completions: top, inline, bottom, none
      show_completions_on_input = true; # Show completions while typing
      show_completion_documentation = true; # Show documentation in completions
      auto_signature_help = true; # Show method signatures inside parentheses
      # Whether to show the signature help after completion or a bracket pair inserted.
      # If `auto_signature_help` is enabled, this setting will be treated as enabled also.
      show_signature_help_after_edits = false;
      inline_code_actions = true; # Whether to show code action button at start of buffer line.
      diagnostics_max_severity = null; # Which level to use to filter out diagnostics displayed in the editor: off, error, warning, info, hint, null (all)
      lsp_document_colors = "inlay"; # How to render LSP `textDocument/documentColor` colors in the editor. none, inlay, border, background
      completion_menu_scrollbar = "never"; # When to show the scrollbar in the completion menu. auto, system, always, never
      colorize_brackets = true; # Turn on colorization of brackets in editors (configurable per language)
      #########################

      edit_predictions = {
        mode = "eager"; # Automatically show (eager) or hold-alt (subtle)
        enabled_in_text_threads = true; # Show/hide predictions in agent text threads
      };
      show_edit_predictions = true; # Show/hide predictions in editor

      ## TODO impo test every impo
      inlay_hints = {
        enabled = false;
        show_type_hints = true; # Toggle certain types of hints on and off, all switched on by default.
        show_parameter_hints = true;
        show_other_hints = true;
        show_background = false; # Whether to show a background for inlay hints (theme `hint.background`)
        edit_debounce_ms = 700; # Time to wait after editing before requesting hints (0 to disable debounce)
        scroll_debounce_ms = 50; # Time to wait after scrolling before requesting hints (0 to disable debounce)
        # A set of modifiers which, when pressed, will toggle the visibility of inlay hints.sss
        toggle_on_modifiers_press = {
          control = false;
          shift = false;
          alt = false;
          platform = false;
          function = false;
        };
      };
      #############
      #
      project_panel = {
        button = true;
        default_width = 200;
        dock = "left";
        entry_spacing = "comfortable";
        file_icons = true;
        folder_icons = true;
        git_status = true;
        indent_size = 10;
        auto_reveal_entries = true;
        auto_fold_dirs = true;
        sticky_scroll = true;
        drag_and_drop = true;
        scrollbar = {
          show = null;
        };
        show_diagnostics = "all";
        indent_guides = {
          show = "always";
        };
        sort_mode = "directories_first";
        hide_root = false;
        hide_hidden = false;
      };

      indent_guides = {
        enabled = true;
        line_width = 1;
        active_line_width = 2;
        # coloring = "indent_aware";
        # background_coloring = "indent_aware";
      };
    };
  };
  home.packages = [
    pkgs.nixd
    pkgs.nil
    pkgs.nixfmt-rfc-style
    pkgs.alejandra
  ];
  home.file.".zed_server" = {
    source = "${pkgs.zed-editor.remote_server}/bin";
    # keeps the folder writable, but symlinks the binaries into it
    recursive = true;
  };

}
