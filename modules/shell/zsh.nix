#
#  Shell
#

{ pkgs, vars, ... }:
let 
  dot_zsh_exports = ''
    export SOPS_AGE_KEY_FILE=$HOME/.sops/key.txt
  '';
  dot_zsh_aliases = ''
    alias ls='ls --color=auto'
    alias man-list="man \$(apropos --long . | dmenu -i -l 30 | awk '{print \$2, \$1}' | tr -d '()')"
    alias update_grub="sudo grub-mkconfig -o /boot/grub/grub.cfg"
    alias update_all='yes | yay && yes | yay -Yc && flatpak update -y && flatpak uninstall --unused && _chezmoi_sync_local'
    alias update=update_all
    alias looking-glass-client="looking-glass-client -m 99 win:size=1920x1080"
    alias restart_displayserver="sudo systemctl restart lightdm"
    alias yay_clean="yay -cc && yay -Sc"
    alias _chezmoi_sync_local="chezmoi re-add" #re adds all watched files and commits changes
    alias ssh='TERM=xterm-color ssh'
    alias k9s='EDITOR=vim k9s'
    alias kubectl='EDITOR=vim kubectl'
    alias kubectl_pod_status="kubectl get events --all-namespaces  --sort-by='.metadata.creationTimestamp'"
    #nixos
    alias nixos_config_update="sudo nixos-rebuild switch --flake ~/.flake#$flake_name"
    alias nixos_update="nix_update"
    alias nix_update="nix flake update ~/.flake && nixos_config_update"
    #git
    alias git='EDITOR=vim git'
    alias gs='EDITOR=vim git status'
    alias gl='EDITOR=vim git log --oneline'
    alias gm='EDITOR=vim git commit -m'
    alias gp='EDITOR=vim git push --force-with-lease'
    #kubecli
    alias k=kubectl 
    alias ka="kubectl apply"
    alias kd="kubectl delete"
    # #sops
    SOPS_AGE_PUBLIC_KEY=$(cat $SOPS_AGE_KEY_FILE | grep -oP "public key: \K(.*)") # tasking for execution
    alias sops_encrypt="sops --encrypt --age $SOPS_AGE_PUBLIC_KEY -i"
    alias sops_decrypt="sops --decrypt --age $SOPS_AGE_PUBLIC_KEY -i"
    alias sops_stringData_encrypt="sops --encrypt --age $SOPS_AGE_PUBLIC_KEY --encrypted-regex '^(data|stringData)$' --in-place"
    alias sops_stringData_decrypt="sops --decrypt --age $SOPS_AGE_PUBLIC_KEY --encrypted-regex '^(data|stringData)$' --in-place"
    alias sops_data_encrypt="sops --encrypt --age $SOPS_AGE_PUBLIC_KEY --encrypted-regex '^(data|data)$' --in-place"
    alias sops_file_encrypt="sops --encrypt --age $SOPS_AGE_PUBLIC_KEY --in-place"
    alias sops_file_decrypt="sops --decrypt --age $SOPS_AGE_PUBLIC_KEY --in-place"
    alias sops_value_encrypt="sops --encrypt --age $SOPS_AGE_PUBLIC_KEY --encrypted-regex '^(values)$' --in-place"
    #flux
    alias flux_get_states="flux get all -A --status-selector ready=false" #gets debug state of deployed serivces helm
    alias flux_update_repo="flux reconcile source git fluxcd-kubernetes; flux reconcile kustomization cluster; flux reconcile kustomization cluster-apps"
    alias ls='ls --color=auto'
  '';
  dot_zsh_binds = ''
    bindkey  "^[[H"   beginning-of-line
    bindkey "^[OH" beginning-of-line
    bindkey  "^[[F"   end-of-line
    bindkey "^[OF" end-of-line
    bindkey  "^[[3~"  delete-char
    bindkey "^[[1;5C" vi-forward-word
    bindkey "^[[1;5D" vi-backward-word
    bindkey "^[[1;6C" forward-word
    bindkey "^[[1;6D" backward-word
    bindkey "^H" vi-backward-kill-word
    bindkey "5~" kill-word 
    # [[3;5~
  '';
in 
{
  users.users.${vars.user} = {
    shell = pkgs.zsh;
  };
  # programs = {
  #   zsh = {
  #     enable = true;
  #     # shellInit = ''
  #     #   # Spaceship
  #     #   #source ~/.config/zsh/.zshrc
  #     #   # autoload -U promptinit; promptinit
  #     #   # Hook direnv
  #     #   #emulate zsh -c "$(direnv hook zsh)"

  #     #   #eval "$(direnv hook zsh)"
  #     # '';                                       # Theming
  #   };
  # };
  home-manager.users.${vars.user} = {
    programs.zsh = {
      enable=true;
      defaultKeymap = "emacs"; #emacs vicmd viins
      enableAutosuggestions = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      # enableVteIntegration = true; #notsure ,but seems usefull
      completionInit = "autoload -U colors && colors\nautoload -U compinit && compinit\nautoload -Uz vcs_info";
      dotDir=".config/zsh";
      # history.share = true;
      history.size = 50000;
      history.save = 50000;
      initExtra=''
          ${dot_zsh_binds}
          ${dot_zsh_exports}
          ${dot_zsh_aliases}
          unset SSH_AUTH_SOCK   # fuck you gnome keyring
          PROMPT='%B%F{cyan}%n%f@%F{blue}%M:%F{magenta}%~%F{purple}>%b%f '
      '';   
      # initExtra="zstyle ':vcs_info:git:*' formats '%b'\nsetopt PROMPT_SUBST\nPROMPT='%B%F{cyan}%n%f@%F{blue}%M:%F{magenta}%~%F{red}\${vcs_info_msg_0_}%F{purple}>%b%f '";
      # oh-my-zsh.enable = true;
      # oh-my-zsh.theme = "";
    };   
    services.gpg-agent.enableZshIntegration = true;
    services.gpg-agent = {
      enable = true;
      defaultCacheTtl = 1800;
      enableSshSupport = true;
    };
  };
}