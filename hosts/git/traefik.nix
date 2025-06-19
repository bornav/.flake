{ config, lib, host, inputs, pkgs, pkgs-unstable, ... }:
# let
#   pkgs = import inputs.nixpkgs-unstable {
#     system = host.system;
#     config.allowUnfree = true;
#   };
#   pkgs-unstable = import inputs.nixpkgs-unstable {
#     system = host.system;
#     config.allowUnfree = true;
#   };
# in
{
  # services.traefik = {
  #   enable = true;
  #   staticConfigOptions = {
  #     entryPoints = {
  #       web = {
  #         address = ":80";
  #         asDefault = true;
  #         http.redirections.entrypoint = {
  #           to = "websecure";
  #           scheme = "https";
  #         };
  #       };

  #       websecure = {
  #         address = ":443";
  #         asDefault = true;
  #         http.tls.certResolver = "letsencrypt";
  #       };
  #     };

  #     log = {
  #       level = "INFO";
  #       filePath = "${config.services.traefik.dataDir}/traefik.log";
  #       format = "json";
  #     };

  #     certificatesResolvers.letsencrypt.acme = {
  #       email = "postmaster@YOUR.DOMAIN";
  #       storage = "${config.services.traefik.dataDir}/acme.json";
  #       httpChallenge.entryPoint = "web";
  #     };

  #     api.dashboard = true;
  #     # Access the Traefik dashboard on <Traefik IP>:8080 of your server
  #     # api.insecure = true;
  #   };

  #   dynamicConfigOptions = {
  #     http.routers = {};
  #     http.services = {};
  #   };
  # };
}