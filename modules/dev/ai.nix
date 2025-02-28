{ config, inputs, system, vars, lib, pkgs, ... }:
# let
#     pkgs = import inputs.nixpkgs-unstable {
#         config.allowUnfree = true;
#         inherit system;
#     };
# in
with lib;
{

  config = mkIf (config.ai.enable) {
    environment.systemPackages = with pkgs; [
        # ollama
        # lmstudio
        # gpt4all
        # tabby
        # nvidia-container-toolkit # TODO breaks normal docker(overwrites)
        onnxruntime
      ];
    # services.tabby.enable = true;
    # networking.firewall = {
    #   enable = true;
    #   allowedTCPPorts = [ 8080 ];
    #   allowedUDPPorts = [ 8080 ];
    # };
  };
}
