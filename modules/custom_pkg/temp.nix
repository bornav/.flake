# beyla.nix
{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "beyla";
  version = "3.7.0";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "beyla";
    rev = "v${version}";
    hash = "sha256-W9KUFDod0rwpPxh9C0OiAVsAMqo/G85F5z+59qgupa8=";
  };

  vendorHash = null;

  postPatch = ''
    substituteInPlace go.mod \
      --replace-fail \
        $'replace go.opentelemetry.io/obi => ./.obi-src\n' \
        ""
    sed -i 's| => \./\.obi-src||g' vendor/modules.txt
  '';
  subPackages = ["cmd/beyla"];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=v${version}"
  ];

  env.CGO_ENABLED = "0";

  meta = with lib; {
    description = "eBPF-based autoinstrumentation of web applications and network metrics";
    homepage = "https://github.com/grafana/beyla";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = [];
  };
}
# stdenv.mkDerivation rec {
#   pname = "beyla";
#   version = "3.7.0";
#   architecture = "amd64";
#   src = fetchurl {
#     url = "https://github.com/grafana/beyla/releases/download/v${version}/${pname}-linux-${architecture}-v${version}.tar.gz";
#     sha256 = "sha256-wTBGKW5HSf6bEF3Ur53Yt8YsK8XsmD0+PS4Pijf5Bgk=";
#   };
#   # No build needed — we're just unpacking a pre-built binary
#   dontBuild = true;
#   dontConfigure = true;
#   # If the tarball has no top-level directory, set this:
#   sourceRoot = ".";
#   installPhase = ''
#     runHook preInstall
#     install -Dm755 ${pname} $out/bin/${pname}
#     runHook postInstall
#   '';
#   meta = with lib; {
#     description = "eBPF-based autoinstrumentation of web applications and network metrics";
#     homepage    = "https://github.com/grafana/beyla";
#     license     = licenses.asl20;
#     platforms   = platforms.linux;
#     maintainers = [];
#   };
# }
