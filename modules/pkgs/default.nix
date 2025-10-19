{
  nixpkgs.overlays = [
    (final: prev: let
      inherit (prev) callPackage;
    in {
      customPkgs = {
        egl-wayland2 = callPackage ./egl-wayland2.nix {};
      };
    })
  ];
}
