{ config, lib, inputs, host, pkgs, pkgs-unstable, ... }:
let
  pkgs-rc6 = import inputs.nixpkgs-kernel-rc6 {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };
  pkgs-rc5 = import inputs.nixpkgs-kernel-rc5 {
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
    k6.configuration = {
      boot.kernelPackages = lib.mkForce pkgs-rc6.linuxPackages_testing;
    };
  #   # k4.configuration = {boot.kernelPackages = lib.mkForce pkgs-unstable.linuxKernel.packages.linux_6_11;};
    k5.configuration = {
      boot.kernelPackages = lib.mkForce pkgs-rc5.linuxPackages_testing;
    };

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
