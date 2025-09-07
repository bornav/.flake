{ config, inputs, system, vars, lib, pkgs, ... }:
# let
#     pkgs = import inputs.nixpkgs-unstable {
#         config.allowUnfree = true;
#         inherit system;
#     };
# in
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

        # programs.vscode = {
        #     enable = true;
        #     # package = pkgs.vscode.fhs;
        #     package = pkgs.vscode.fhsWithPackages (ps: with ps; [ rustup zlib openssl.dev pkg-config ]);
        # };
        
        programs.vscode = {
          enable = true;
          #package = pkgs.vscodium;
          # profiles.default.userSettings = {
          #     "editor.minimap.enabled"= "false";
          #     "terminal.integrated.fontFamily"= "Hack";
          #     "workbench.sideBar.location"= "right";
          #     "workbench.activityBar.location"= "top";
          #     "window.customTitleBarVisibility"= "auto";

          #     "continue.showInlineTip"= false;
          #     "continue.telemetryEnabled" = false;

          #     "direnv.restart.automatic"= true;
          # };
        };
        home.file.".config/Code/User/settings.json" = {
        #home.file.".config/VSCodium/User/settings.json" = {
          text = ''
            {
              "continue.showInlineTip": false,
              "continue.telemetryEnabled": false,
              "direnv.restart.automatic": true,
              "editor.minimap.enabled": "false",
              "terminal.integrated.fontFamily": "Hack",
              "window.customTitleBarVisibility": "auto",
              "workbench.activityBar.location": "top",
              "yaml.schemas": {
                "/home/bocmo/.vscode/extensions/continue.continue-1.0.15-linux-x64/config-yaml-schema.json": [
                  ".continue/**/*.yaml"
                ]
              }
            }
            '';
          force = true;
          mutable = true;
        };
      };
     })
    (lib.mkIf (config.ide.zed) {
      ide.enable = true;
      environment.systemPackages = with pkgs; [
        # zed-editor
      ];
     })
    (lib.mkIf (config.ide.enable) {

      programs.direnv.enable = true;
      environment.systemPackages = with pkgs; [
        # direnv
        istioctl # TODO
      ];
    })
  ];
}
