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
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      enableCompletion = true;
      histSize = 100000;
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
        source ~/.config/zsh/.zshrc
        # autoload -U promptinit; promptinit
        # Hook direnv
        #emulate zsh -c "$(direnv hook zsh)"

        #eval "$(direnv hook zsh)"
      '';                                       # Theming
    };
  };
}