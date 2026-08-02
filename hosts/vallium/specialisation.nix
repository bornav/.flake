{ config, lib, inputs, host, pkgs, pkgs-stable, pkgs-unstable, pkgs-master, ... }:
{
  specialisation = {
   gnome.configuration = {
     gnome.enable = lib.mkForce true;
     plasma.enable = lib.mkForce false;
     hyprland.enable = lib.mkForce false;
   };
  #  hyprland.configuration = {
  #    gnome.enable = lib.mkForce false;
  #    plasma.enable = lib.mkForce false;
  #    hyprland.enable = lib.mkForce true;
  #  };
  #  plasma.configuration = {
  #    gnome.enable = lib.mkForce false;
  #    plasma.enable = lib.mkForce true;
  #    hyprland.enable = lib.mkForce false;
  #  };
  };
}
