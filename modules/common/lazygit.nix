{ config, inputs, system, host, vars, lib, pkgs, ... }:
{
  home-manager.users.${vars.user} = {
    home.file.".config/lazygit/config.yml".text = ''
    git:
      overrideGpg: true
    '';

  };
}
