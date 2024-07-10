{ config, inputs, vars, lib, ... }:
let
    pkgs = import inputs.nixpkgs-unstable {
        config.allowUnfree = true;
        system = "x86_64-linux";
    };
in
with lib;
{
  options = {
    ide = {
      vscode = mkOption {
        type = types.bool;
        default = false;
      };
      zed = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config = lib.mkMerge [

    (lib.mkIf (config.ide.vscode) {
      environment.systemPackages = with pkgs; [
        vscode
        vscode-extensions.continue.continue
      ];
     })
    (lib.mkIf (config.ide.zed) {
      environment.systemPackages = with pkgs; [
        zed
      ];
     })
    (lib.mkIf (config.ide) { })
  ]; 
}
