{
  config,
  inputs,
  system,
  host,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./zsh_config.nix
  ];
  users.users.${host.vars.user} = {
    shell = pkgs.zsh;
  };
  programs.zsh.enable = true;
  home-manager.users.${host.vars.user} = {
    programs.zsh = {
      enable = true;
      defaultKeymap = "emacs"; #emacs vicmd viins
      autosuggestion.enable = true;
      # autosuggestion.highlight = "fg=#ff00ff,bg=cyan,bold,underline";
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      enableVteIntegration = true; #notsure ,but seems usefull
      completionInit = "autoload -U colors && colors\nautoload -U compinit && compinit\nautoload -Uz vcs_info";
      # dotDir=".config/zsh";
      # history = {
      #   size = 50000;
      #   save = 50000;
      #   path = "$HOME/.zsh_history";
      #   ignoreDups = true; # aaabaaaa -> aba
      #   ignoreAllDups = true; # abcda -> bcda
      #   ignoreSpace = true;
      #   share = true; #?
      # };
      initContent = ''
        source ~/.config/zsh/.zsh_binds
        source ~/.config/zsh/.zsh_exports
        source ~/.config/zsh/.zsh_aliases
        source ~/.config/zsh/.zsh_extra_functions
        source ~/.config/zsh/.zsh_shift_select

        eval "$(atuin init zsh)"
        ${lib.optionalString config.services.desktopManager.gnome.enable
          ''
            unset SSH_AUTH_SOCK   # fuck you gnome keyring
          ''}
        PROMPT='%B%F{$(current_user_color)}%n%f@%F{blue}%M:%F{magenta}%~%f$(git_branch_name)%f>%b%f'
      '';

      # prezto = { #seems bloated but might be worth considering
      #   enable = true;
      #   autosuggestions.color = "fg=blue";
      # };

      # historySubstringSearch = { #unknown how to test/what it's supposed to do
      #   enable = true;
      #   searchUpKey = ["^[[B"];
      #   searchDownKey = ["^[[B"];
      # };

      # initExtra="zstyle ':vcs_info:git:*' formats '%b'\nsetopt PROMPT_SUBST\nPROMPT='%B%F{cyan}%n%f@%F{blue}%M:%F{magenta}%~%F{red}\${vcs_info_msg_0_}%F{purple}>%b%f '";
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
        ];
      };
    };

    #
    services.gpg-agent.enableZshIntegration = true;
    services.gpg-agent = {
      enable = true;
      defaultCacheTtl = 1800;
      enableSshSupport = true;
    };
  };
  environment.systemPackages = [
    pkgs.atuin
  ];
  #Enable zsh completion. Don’t forget to add
  environment.pathsToLink = ["/share/zsh"];
}
