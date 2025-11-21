{ config, inputs, system, host, vars, lib, pkgs, ... }:
{
  home-manager.users.${vars.user} = {
    home.file.".config/zsh/.zsh_aliases".text = ''
    alias ls='ls --color=auto'
    alias man-list="man \$(apropos --long . | dmenu -i -l 30 | awk '{print \$2, \$1}' | tr -d '()')"
    alias update_grub="sudo grub-mkconfig -o /boot/grub/grub.cfg"
    alias update_all='yes | yay && yes | yay -Yc && flatpak update -y && flatpak uninstall --unused && _chezmoi_sync_local'
    alias update=update_all
    alias looking-glass-client="looking-glass-client -m 99 win:size=1920x1080"
    alias restart_displayserver="sudo systemctl restart lightdm"
    alias yay_clean="yay -cc && yay -Sc"
    alias _chezmoi_sync_local="chezmoi re-add" #re adds all watched files and commits changes
    alias ssh='TERM=xterm-color ssh -o StrictHostKeychecking=no -o UserKnownHostsFile=/dev/null'
    alias sftp='sftp -o RemoteCommand=none -o RequestTTY=no' # this is here in case we add remotecommand to the ssh config file
    alias k9s='EDITOR=vim k9s'
    alias kubectl='EDITOR=vim kubectl'
    alias kubectl_pod_status="kubectl get events --all-namespaces  --sort-by='.metadata.creationTimestamp'"
    #ide
    alias zed=zeditor
    #alias code=codium
    alias code=zeditor

    #nixos
    alias nixos_config_update="nh os switch ~/.flake -H $flake_name --ask && nix-channel --update"
    #                         "nh os switch ~/.flake -H $flake_name --ask -- --builders ssh://nixbuilder_dockeropen"
    alias nixos_rebuild="~/.flake/rebuild.sh"
    alias nixos_rebuild_remote="sudo nixos-rebuild switch --flake ~/.flake#dockeropen --use-remote-sudo --target-host nixbuilder_dockeropen"
    alias nixos_update="nix flake update --flake ~/.flake && nixos_config_update"
    alias nixos_garbage_collection="nix-collect-garbage --delete-older-than 30d && nixos_config_update"
    # nh clean all -k 15 this can be added to command above, untested how it works
    # alias nix_update="nixos_config_update --update"
    # alias nixos_config_update="sudo nixos-rebuild switch --flake ~/.flake#$flake_name"
    # alias nix_update="nix flake update ~/.flake && nixos_config_update"

    #git
    alias git='EDITOR=vim git'
    alias gs='EDITOR=vim git status'
    alias gl='EDITOR=vim git log --oneline'
    alias gm='EDITOR=vim git commit -m'
    alias gp='EDITOR=vim git push --force-with-lease'
    alias git_check='git diff --cached'   #displays diff of added but not commited files
    alias git_check_commited='git diff @{u}.. --name-only && git diff @{u}'  #displays diff of commited files but not pushed
    alias git_squash='#TODO' squashes current commit to previous one
    alias DEPLOY_PLASMA_SHELL="XDG_SESSION_TYPE=wayland dbus-run-session startplasma-wayland" #https://www.linuxquestions.org/questions/slackware-14/how-to-start-wayland-kde-from-command-line-4175695918/
    #kubecli
    alias k=kubectl
    alias ka="kubectl apply"
    alias kd="kubectl delete"
    alias kbka="kustomize build ./ --enable-helm  | kubectl apply  -f - "
    alias kbkd="kustomize build ./ --enable-helm  | kubectl delete  -f - "
    remove_namespace() {  # example klubectl_nuke_namespace $NAMESPACE
      NAMESPACE=$1
      kubectl proxy &
      PROXY_PID=$!
      sleep 2
      kubectl get namespace $NAMESPACE -o json | jq '.spec = {"finalizers":[]}' > temp.json
      curl -k -H "Content-Type: application/json" -X PUT --data-binary @temp.json 127.0.0.1:8001/api/v1/namespaces/$NAMESPACE/finalize
      kill $PROXY_PID
      rm temp.json
    }
    alias kubectl_nuke_namespace="remove_namespace"
    # #sops
    SOPS_AGE_PUBLIC_KEY=$(cat $SOPS_AGE_KEY_FILE | grep -oP "public key: \K(.*)") # tasking for execution
    alias sops_encrypt="sops --encrypt --age $SOPS_AGE_PUBLIC_KEY -i"
    alias sops_decrypt="sops --decrypt --age $SOPS_AGE_PUBLIC_KEY -i"
    alias sops_stringData_encrypt="sops --encrypt --age $SOPS_AGE_PUBLIC_KEY --encrypted-regex '^(data|stringData)$' --in-place"
    alias sops_stringData_decrypt="sops --decrypt --age $SOPS_AGE_PUBLIC_KEY --encrypted-regex '^(data|stringData)$' --in-place"
    alias sops_multivalue_encrypt="sops --encrypt --age $SOPS_AGE_PUBLIC_KEY --encrypted-regex '^(data|stringData|spec)$' --in-place"
    alias sops_multivalue_decrypt="sops --decrypt --age $SOPS_AGE_PUBLIC_KEY --encrypted-regex '^(data|stringData|spec)$' --in-place"
    alias sops_data_encrypt="sops --encrypt --age $SOPS_AGE_PUBLIC_KEY --encrypted-regex '^(data|data)$' --in-place"
    alias sops_file_encrypt="sops --encrypt --age $SOPS_AGE_PUBLIC_KEY --in-place"
    alias sops_file_decrypt="sops --decrypt --age $SOPS_AGE_PUBLIC_KEY --in-place"
    alias sops_value_encrypt="sops --encrypt --age $SOPS_AGE_PUBLIC_KEY --encrypted-regex '^(values)$' --in-place"
    #flux
    alias flux_get_states="flux get all -A --status-selector ready=false" #gets debug state of deployed serivces helm
    alias flux_update_repo="flux reconcile source git fluxcd-kubernetes; flux reconcile kustomization cluster; flux reconcile kustomization cluster-apps"
    alias ls='ls --color=auto'

    alias neofetch="fastfetch"

    #qemu
    vm_name="ubuntu24.04"
    alias qemu_start="sudo virsh start $vm_name"
    alias qemu_stop="sudo virsh shutdown $vm_name"

    #uncommon
    alias avahi_discover_local="avahi-browse --all --ignore-local --resolve --terminate"   #discovers local mdns records
    '';
    home.file.".config/zsh/.zsh_exports".text = ''
    export SOPS_AGE_KEY_FILE=$HOME/.sops/key.txt
    export PATH=$PATH:~/.local/bin
    '';

    home.file.".config/zsh/.zsh_binds".text = ''
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
    home.file.".config/zsh/.zsh_extra_functions".text = ''
    function git_branch_name()
    {
        branch=$(git symbolic-ref HEAD 2> /dev/null | awk 'BEGIN{FS="/"} {print $NF}')
        if [[ $branch == "" ]];
        then
        :
        else
        echo %f %F{#691593}$branch%f
        fi
    }
    function current_user_color()
    {
        if [[ $EUID == 0 ]]; then
            user_color=red
        elif [[ $USER == "user" && $HOST == "vallium" ]]; then
            user_color=cyan
        else
            # export hex_chars="''${!USER:0:2}"
            # export user_color=$(printf "%d" "0x$hex_chars")
            user_color=5
            # 183
        fi
        echo $user_color
    }
    '';
    home.file.".config/zsh/.zsh_shift_select".text = ''
    function zle-line-init {
    marking=0
    }
    zle -N zle-line-init

    function select-char-right {
        if (( $marking != 1 ))
        then
            marking=1
            zle set-mark-command
        fi
        zle .forward-char
    }
    zle -N select-char-right

    function select-char-left {
        if (( $marking != 1 ))
        then
            marking=1
            zle set-mark-command
        fi
        zle .backward-char
    }
    zle -N select-char-left

    function forward-char {
        if (( $marking == 1 ))
        then
            marking=0
            NUMERIC=-1 zle set-mark-command
        fi
        zle .forward-char
    }
    zle -N forward-char

    function backward-char {
        if (( $marking == 1 ))
        then
            marking=0
            NUMERIC=-1 zle set-mark-command
        fi
        zle .backward-char
    }
    zle -N backward-char

    function delete-char {
        if (( $marking == 1 ))
        then
            zle kill-region
            marking=0
        else
            zle .delete-char
        fi
    }
    zle -N delete-char
    '';

  };
}
