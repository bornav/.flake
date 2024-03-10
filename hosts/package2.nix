{ pkgs ? import <nixpkgs> {} }:
let
  thoriumVersion = "121.0.6167.204";
  thoriumSrc = {
    x86_64-linux = "https://github.com/Alex313031/thorium/releases/download/M${thoriumVersion}/Thorium_Browser_${thoriumVersion}_SSE3.AppImage";
    aarch64-linux = "https://github.com/Alex313031/Thorium-Raspi/releases/download/M${thoriumVersion}/Thorium_Browser_${thoriumVersion}_arm64.AppImage";
  };
  
  makeThorium = system: let
    name = "thorium";
    version = thoriumVersion;
    src = pkgs.fetchurl {
      url = thoriumSrc.${system};
      sha256 = "1be67ce70edded84ffd37b6a707d553091a87a7a1e81cb6d6f1cf7f2ed0959c2";
    };
    appimageContents = pkgs.appimageTools.extractType2 { inherit name src; };
  in pkgs.appimageTools.wrapType2 {
    inherit name version src;
    extraInstallCommands = ''
      install -Dm444 ${appimageContents}/thorium-browser.desktop $out/share/applications/thorium-browser.desktop
      install -Dm444 ${appimageContents}/thorium.png $out/share/icons/hicolor/512x512/apps/thorium.png
    '';
  };
in
{
  thorium_x86_64-linux = makeThorium "x86_64-linux";
  thorium_aarch64-linux = makeThorium "aarch64-linux";
}