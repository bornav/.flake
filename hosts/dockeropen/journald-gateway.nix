{ config, lib, host, inputs, ... }:
let
  pkgs = import inputs.nixpkgs-unstable {
    system = host.system;
    config.allowUnfree = true;
  };
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = host.system;
    config.allowUnfree = true;
  };
in
{
  services.journald = {
    # enable = true;
    extraConfig = ''
      ForwardToSyslog=yes
      MaxRetentionSec=5day
      SystemMaxUse=500M
    '';
  };

  # Configure rsyslog
  services.rsyslog = {
    enable = true;
    extraConfig = ''
      # Load required modules
      module(load="imuxsock")
      module(load="imjournal")

      # Set journal defaults
      module(load="imjournal" 
          StateFile="imjournal.state"
          Ratelimit.Interval="0"
          Ratelimit.Burst="0"
      )

      # Forward all logs to OTel collector
      *.* action(
          type="omfwd"
          target="localhost" 
          port="4317"
          protocol="tcp"
          Template="RSYSLOG_SyslogProtocol23Format"
      )
    '';
  };

  # Create a systemd service for the journal gateway
  systemd.services.journal-gateway = {
    description = "Journal Gateway Service";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    
    serviceConfig = {
      ExecStart = "${pkgs.systemd}/lib/systemd/systemd-journal-gatewayd " +
                 "--output-journal=/var/log/journal " +
                 "--forward-to-syslog=yes " +
                 "--forward-to-syslog-format=rfc5424 " +
                 "--forward-to-syslog-host=localhost " +
                 "--forward-to-syslog-port=4318";
      DynamicUser = true;
      StateDirectory = "journal";
    };
  };

  # Ensure the journal directory exists and has correct permissions
  systemd.tmpfiles.rules = [
    "d /var/log/journal 2755 root systemd-journal - -"
  ];

}