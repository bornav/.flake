{ config, lib, system, inputs, host, pkgs, pkgs-unstable, pkgs-master, ... }:  # TODO remove system, only when from all modules it is removed
{
  services = {
    ollama = {
      enable = true;
      acceleration = "rocm";
      openFirewall = true;
      rocmOverrideGfx = "11.0.0";
    };
  };
}
