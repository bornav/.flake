#
#  Shell
#

{ pkgs, vars, ... }:

{
  users.users.${vars.user} = {
    shell = pkgs.zsh;
  };

  programs = {
    zsh = {
      enable = true;
      # autosuggestions.enable = true;
      # syntaxHighlighting.enable = true;
      # enableCompletion = true;
      # histSize = 100;
    #   plugins = [
    #     # {
    #     # # will source zsh-autosuggestions.plugin.zsh
    #     # name = "zsh-autosuggestions";
    #     # src = pkgs.fetchFromGitHub {
    #     #     owner = "zsh-users";
    #     #     repo = "zsh-autosuggestions";
    #     #     rev = "v0.4.0";
    #     #     sha256 = "0z6i9wjjklb4lvr7zjhbphibsyx51psv50gm07mbb0kj9058j6kc";
    #     # };
    #     # }
    #     {
    #     name = "zsh-syntax-highlighting";
    #     file = "zsh-syntax-highlighting";
    #     src = pkgs.fetchFromGitHub {
    #         owner = "zsh-users";
    #         repo = "zsh-syntax-highlighting";
    #         rev = "0.7.1";
    #         sha256 = "0iqa9j09fwm6nj5rpip87x3hnvbbz9w9ajgm6wkrd5fls8fn8i5g";
    #     };
    #     }
    # ];

    #   ohMyZsh = {                               # Plug-ins
    #     enable = true;
    #     plugins = [ "git" ];
    #   };

      shellInit = ''
        # Spaceship
        #source ~/.config/zsh/.zshrc
        # autoload -U promptinit; promptinit
        # Hook direnv
        #emulate zsh -c "$(direnv hook zsh)"

        #eval "$(direnv hook zsh)"
      '';                                       # Theming
    };
  };
  home-manager.users.${vars.user} = {
    programs.zsh = {
      enable=true;
      defaultKeymap = "emacs"; #emacs vicmd viins
      enableAutosuggestions = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      enableVteIntegration = true; #notsure ,but seems usefull
      completionInit = "autoload -U colors && colors\nautoload -U compinit && compinit\nautoload -Uz vcs_info";
      dotDir=".config/zsh";
      history.share = true;
      history.size = 50000;
      history.save = 50000;
      initExtra=''
          bindkey  "^[[H"   beginning-of-line
          bindkey  "^[[F"   end-of-line
          bindkey  "^[[3~"  delete-char
          bindkey "^[[1;5C" vi-forward-word
          bindkey "^[[1;5D" vi-backward-word
          bindkey "^[[1;6C" forward-word
          bindkey "^[[1;6D" backward-word
          bindkey "^H" vi-backward-kill-word
          PROMPT='%B%F{cyan}%n%f@%F{blue}%M:%F{magenta}%~%F{purple}>%b%f '
      '';   
      # initExtra="zstyle ':vcs_info:git:*' formats '%b'\nsetopt PROMPT_SUBST\nPROMPT='%B%F{cyan}%n%f@%F{blue}%M:%F{magenta}%~%F{red}\${vcs_info_msg_0_}%F{purple}>%b%f '";
      # oh-my-zsh.enable = true;
      # oh-my-zsh.theme = "";
    };
    services.gpg-agent.enableZshIntegration = true;
  };
}