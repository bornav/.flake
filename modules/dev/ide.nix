{ config, inputs, system, vars, lib, ... }:
let
    pkgs = import inputs.nixpkgs-unstable {
        config.allowUnfree = true;
        inherit system;
    };
in
with lib;
{
  config = lib.mkMerge [
    (lib.mkIf (config.ide.vscode) {
      ide.enable = true;
      # environment.systemPackages = with pkgs; [
      #   vscode
      # #   vscode-extensions.continue.continue
      # ];
      # environment.systemPackages = with pkgs; [
      #   vscode
      #   (vscode-with-extensions.override {
      #     vscodeExtensions = with vscode-extensions; [
      #       continue.continue
      #     #   bbenoist.nix
      #     #   ms-python.python
      #     #   ms-azuretools.vscode-docker
      #     #   ms-vscode-remote.remote-ssh
      #     # ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      #     #   {
      #     #     name = "remote-ssh-edit";
      #     #     publisher = "ms-vscode-remote";
      #     #     version = "0.47.2";
      #     #     sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
      #     #   }
      #     ];
      #   })
      # ];
      # environment.systemPackages = with pkgs; [ vscode-fhs ];

      home-manager.users.${vars.user} = {
        # home.packages = with pkgs; [
        #   (vscode-with-extensions.override {
        #     vscodeExtensions = with vscode-extensions; [
        #       bbenoist.nix
        #       ms-python.python
        #       ms-azuretools.vscode-docker
        #       # ms-vscode-remote.remote-ssh
        #     # ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        #     #   {
        #     #     name = "remote-ssh-edit";
        #     #     publisher = "ms-vscode-remote";
        #     #     version = "0.47.2";
        #     #     sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
        #     #   }
        #     ];
        #   })
        # ];
        programs.vscode = {
          enable = true;
          package = pkgs.vscode;
          # extensions = with pkgs.vscode-extensions; [
          #     continue.continue
          # ];
          profiles.default.userSettings = {
              "editor.minimap.enabled"= "false";
              "terminal.integrated.fontFamily"= "Hack";
              "workbench.sideBar.location"= "right";
              "workbench.activityBar.location"= "top";
              "window.customTitleBarVisibility"= "auto";
          };
        };
        # programs.vscode = {
        #     enable = true;
        #     # package = pkgs.vscode.fhs;
        #     package = pkgs.vscode.fhsWithPackages (ps: with ps; [ rustup zlib openssl.dev pkg-config ]);
        # };
      };
     })
    (lib.mkIf (config.ide.zed) {
      ide.enable = true;
      environment.systemPackages = with pkgs; [
        # zed-editor
      ];
     })
    (lib.mkIf (config.ide.enable) {
      environment.systemPackages = with pkgs; [
        istioctl # TODO
      ];
    })
  ];
}
