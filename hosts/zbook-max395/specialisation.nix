{ config, lib, inputs, host, pkgs, pkgs-unstable, ... }:
let
  pkgs-oldkern = import inputs.nixpkgs-6-16-kernel {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };
in
{

  specialisation = {
    # k1-unmodified.configuration = {
    #   boot.kernelPackages = lib.mkForce pkgs-oldkern.linuxKernel.packages.linux_6_17;};
    # k2-patched.configuration = {
    #   boot.kernelPackages = lib.mkForce pkgs-oldkern.linuxKernel.packages.linux_6_17;
    #   boot.kernelPatches = [
    #           { name = "amdgpu-patch";
    #             patch = ./kernel.patch;
    #           }
    #         ];
    # };
    k3.configuration = {boot.kernelPackages = pkgs-unstable.linuxPackages_latest;};
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
  };
}
