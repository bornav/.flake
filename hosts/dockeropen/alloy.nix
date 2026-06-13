{
  lib,
  pkgs-local,
  ...
}: let
  docker_socket = "unix:///var/run/docker.sock";
  # docker_socket = "unix:///var/run/podman/podman.sock";
  prometheus_ingest = "http://prometheus.internal:9090/api/v1/write";
  loki_ingest = "http://loki.internal:3100/loki/api/v1/push";
  otel_ingest = "otel-collector.internal:4318";
  # otel_ingest = "10.2.11.42:3418";
  pytoscope_ingest = "http://pyroscope.internal:4100";
in {
  ####################### all required in order for alloy to have perm access to docker/podman socket
  users.groups.alloy = {};
  users.users.alloy.isSystemUser = true;
  users.users.alloy.group = "alloy";
  users.users.alloy.extraGroups = ["docker" "podman"];
  ####################################################
  services.alloy.enable = true;
  services.alloy.extraFlags = ["--disable-reporting"]; # this removes the anon usage statistics
  environment.etc."alloy/config.alloy".text = lib.mkForce ''
    otelcol.exporter.otlphttp "local" {
      client {
        endpoint = "http://${otel_ingest}"
        timeout = "30s"
        tls {
          insecure = true
        }
      }
    }
    otelcol.processor.batch "default" {
      timeout = "10s"
      send_batch_size = 100
      send_batch_max_size = 200
      output {
        logs = [otelcol.exporter.otlphttp.local.input]
        metrics = [otelcol.exporter.otlphttp.local.input]
        traces = [otelcol.exporter.otlphttp.local.input]
      }
    }
    otelcol.receiver.loki "default" {
      output {
        logs = [otelcol.processor.batch.default.input]
      }
    }
    otelcol.receiver.prometheus "default" {
      output {
        metrics = [otelcol.processor.batch.default.input]
      }
    }
    prometheus.exporter.unix "node" {}
    prometheus.scrape "linux_node" {
      targets = prometheus.exporter.unix.node.targets
      forward_to = [otelcol.receiver.prometheus.default.receiver]
    }
    loki.relabel "journal" {
      forward_to = []
      rule {
        source_labels = ["__journal__systemd_unit"]
        target_label = "unit"
      }
      rule {
        source_labels = ["__journal__boot_id"]
        target_label = "boot_id"
      }
      rule {
        source_labels = ["__journal__transport"]
        target_label = "transport"
      }
      rule {
        source_labels = ["__journal_priority_keyword"]
        target_label = "level"
      }
      rule {
        source_labels = ["__journal__hostname"]
        target_label = "instance"
      }
    }
    loki.source.journal "read" {
      forward_to = [otelcol.receiver.loki.default.receiver]
      relabel_rules = loki.relabel.journal.rules
      labels = {
        "job" = "integrations/node_exporter",
      }
    }
    discovery.docker "linux" {
      host = "${docker_socket}"
    }
    discovery.relabel "logs_integrations_docker" {
        targets = discovery.docker.linux.targets
        rule {
            target_label = "job"
            replacement  = "integrations/docker"
        }
        rule {
            target_label = "instance"
            replacement  = constants.hostname
        }
        rule {
            source_labels = ["__meta_docker_container_name"]
            regex         = "/(.*)"
            target_label  = "container"
        }
        rule {
            source_labels = ["__meta_docker_container_log_stream"]
            target_label  = "stream"
        }
    }
    loki.source.docker "default" {
      host = "${docker_socket}"
      targets = discovery.relabel.logs_integrations_docker.output
      relabel_rules = discovery.relabel.logs_integrations_docker.rules
      labels = {}
      forward_to = [otelcol.receiver.loki.default.receiver]
    }
  '';

  systemd.services.beyla = {
    after = [ "network.target"];
    # environment = { BEYLA_NETWORK_PRINT_FLOWS = "true";};
    serviceConfig = {
      ExecStart = "${pkgs-local.beyla}/bin/beyla -config /etc/beyla/config.yaml";
      Restart = "on-failure";
      RestartSec = "5s";
      RemainAfterExit = true;
    };
    wantedBy = [ "multi-user.target" ];
  };
  environment.systemPackages = [pkgs-local.beyla];
  environment.etc."beyla/config.yaml".text = lib.mkForce ''
    network:
      enable: true
    # log_level: DEBUG
    discovery:
      instrument:
        - open_ports: 80-9999
    otel_metrics_export:
      endpoint: http://localhost:4318
    otel_traces_export:
      endpoint: http://localhost:4318
    ebpf:
      context_propagation: all
      track_request_headers: true
  '';
}
