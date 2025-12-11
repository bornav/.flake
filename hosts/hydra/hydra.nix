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
  # https://github.com/NixOS/hydra
  services.hydra = {
    enable = true;
    hydraURL = "https://hydra.icylair.com";
    notificationSender = "hydra@localhost";
    # buildMachinesFiles = [];
    useSubstitutes = true;
    extraConfig = ''
        <git-input>
          timeout = 3600
        </git-input>
      '';
  };
  nix.buildMachines = [
    { hostName = "localhost";
      protocol = null;
      system = "x86_64-linux";
      supportedFeatures = ["kvm" "nixos-test" "big-parallel" "benchmark"];
      maxJobs = 8;
    }
  ];
  users = {
    users.hydra = {
      extraGroups = [ "networkmanager" "wheel" "root"];
    };
  };

  # # for serving TODO
  # services.nix-serve = {
  #   enable = true;
  #   secretKeyFile = "/var/cache-priv-key.pem";
  # };


  # services.hydra.extraConfig = ''
  #    enable_hydra_login = 0                                                     # disable default hydra login page
  #    enable_oidc_login = 1                                                      # enable OIDC
  #    oidc_client_id = "hydra"                                                   # this should match the client id in kanidm config
  #    oidc_scope = "openid email profile groups"                                 # scopes to request
  #    oidc_auth_uri = "https://sso.icylair.com.com/ui/oauth2"                        # kanidm oauth2 auth endpoint
  #    oidc_token_uri = "https://sso.example.com/oauth2/token"                    # kanidm oauth2 token endpoint
  #    oidc_userinfo_uri = "https://sso.example.com/oauth2/openid/hydra/userinfo" # kanidm userinfo endpoint, client id must match
  #    include ${config.sops.secrets.hydra.path}                                  # should contain `oidc_client_secret = <secret>`

  #    # change the role mapping according to your needs
  #    # but the the format is:
  #    # <group in kanidm> = <role in hydra>
  #    # where group in kanidm is in the form of
  #    # <group>@<kanidm cookie domain>
  #    <oidc_role_mapping>
  #      hydra.admins@sso.example.com = admin
  #      hydra.admins@sso.example.com = bump-to-front
  #      hydra.users@sso.example.com = cancel-build
  #      hydra.users@sso.example.com = eval-jobset
  #      hydra.users@sso.example.com = create-projects
  #      hydra.users@sso.example.com = restart-jobs
  #    </oidc_role_mapping>
  #  '';

  networking.firewall = {
    allowedTCPPorts = [
      6443 # RKE2 api server
      9345 # RKE2 controll plane
      2379 # k3s, etcd clients: required if using a "High Availability Embedded etcd" configuration
      2380 # k3s, etcd peers: required if using a "High Availability Embedded etcd" configuration
      443 8443 9443 # https
      80 8080 # http

      22 # ssh

      9987 10011 30033 # TS3

      4789 # vxvlan
    ];
    allowedTCPPortRanges = [
    { from = 4; to = 65535; }
    ];
    # allowedUDPPorts = [
    #   # 8472 # k3s, flannel: required if using multi-node for inter-node networking
    #   443 8443 # https
    #   80 8080 # http

    #   9987 10011 30033 # TS3


    #   51872 # wg-mesh

    # ];
    allowedUDPPortRanges = [
    { from = 4; to = 65535; }
    ];
  };
}
