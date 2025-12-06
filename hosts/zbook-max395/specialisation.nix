{ config, lib, inputs, host, pkgs, ... }:
{

  # specialisation = {
  #   # k1.configuration = {boot.kernelPackages = lib.mkForce pkgs-unstable.linuxKernel.packages.linux_6_11;};
  #   k2.configuration = {boot.kernelPackages = lib.mkForce pkgs-unstable.linuxKernel.packages.linux_5_4;};
  #   k3.configuration = {boot.kernelPackages = lib.mkForce pkgs-unstable.linuxKernel.packages.linux_6_6;};
  #   # k4.configuration = {boot.kernelPackages = lib.mkForce pkgs-unstable.linuxKernel.packages.linux_6_11;};

  # };

  # specialisation = {
  # #  gnome.configuration = {
  # #    gnome.enable = lib.mkForce true;
  # #    cosmic-desktop.enable =  lib.mkForce false;
  # #    plasma.enable = lib.mkForce false;
  # #    hyprland.enable = lib.mkForce false;
  # #  };
  # #  hyprland.configuration = {
  # #    cosmic-desktop.enable = lib.mkForce false;
  # #    gnome.enable = lib.mkForce false;
  # #    plasma.enable = lib.mkForce false;
  # #    hyprland.enable = lib.mkForce true;
  # #  };
  # #  cosmic.configuration = {
  # #    cosmic-desktop.enable = lib.mkForce true;
  # #    gnome.enable = lib.mkForce false;
  # #    plasma.enable = lib.mkForce false;
  # #    hyprland.enable = lib.mkForce false;
  # #  };
  #  plasma.configuration = {
  #    cosmic-desktop.enable = lib.mkForce false;
  #    gnome.enable = lib.mkForce false;
  #    plasma.enable = lib.mkForce true;
  #    hyprland.enable = lib.mkForce false;
  #  };
  # };
}
