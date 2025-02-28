{inputs, config, system, vars, ... }:
let
  pkgs = import inputs.nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };
  pkgs-unstable = import inputs.nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };
in
{
  imports = ( import ../../modules/shell ++
              # import ../../modules/terminalEmulators ++
              import ../../modules/virtualization ++
              import ../../modules/dev ++
              import ../../modules/gaming ++
              import ../../modules/common ++
              import ../../modules/vpn ++
              import ../../modules/custom_pkg ++
              import ../../modules/devices ++
              import ../../modules/storage ++
              import ../../modules/nix ++
              import ../../modules/de);
}
