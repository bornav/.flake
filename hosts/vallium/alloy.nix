{
  lib,
  pkgs,
  ...
}: let
  docker_socket = "unix:///var/run/docker.sock";
  # docker_socket = "unix:///var/run/podman/podman.sock";
  prometheus_ingest = "http://prometheus.internal:9090/api/v1/write";
  loki_ingest = "http://loki.internal:3100/loki/api/v1/push";
  otel_ingest = "tempo.internal:4317";
  pytoscope_ingest = "http://pyroscope.internal:4100";
in {
  ####################### all required in order for alloy to have perm access to docker/podman socket
  users.groups.alloy = {};
  users.users.alloy.isSystemUser = true;
  users.users.alloy.group = "alloy";
  users.users.alloy.extraGroups = ["docker" "podman"];
  ####################################################
  services.alloy.enable = true;
  systemd.services."alloy".serviceConfig.TimeoutStopSec = "5s"; # so if it hangs it kills itself in 5s
  services.alloy.extraFlags = ["--disable-reporting"]; # this removes the anon usage statistics
  environment.etc."alloy/config.alloy".text = lib.mkForce ''
    livedebugging {
      enabled = true
    }
    prometheus.remote_write "local" {
      endpoint {
        url = "${prometheus_ingest}"
      }
    }
    loki.write "local" {
      endpoint {
        url = "${loki_ingest}"
      }
    }
    otelcol.exporter.otlp "local" {
      client {
        endpoint = "${otel_ingest}"
      }
    }
    prometheus.scrape "linux_node" {
      targets = prometheus.exporter.unix.node.targets
      forward_to = [
        prometheus.remote_write.local.receiver,
      ]
    }
    prometheus.scrape "nvidia_gpu_exporter" {
      targets = [{"__address__" = "127.0.0.1:9835"}]
      metrics_path = "/metrics"
      forward_to = [
        prometheus.remote_write.local.receiver,
      ]
    }
    prometheus.exporter.unix "node" {}
    loki.relabel "journal" {
      forward_to = []
      rule {
        source_labels = ["__journal__systemd_unit"]
        target_label  = "unit"
      }
      rule {
        source_labels = ["__journal__boot_id"]
        target_label  = "boot_id"
      }
      rule {
        source_labels = ["__journal__transport"]
        target_label  = "transport"
      }
      rule {
        source_labels = ["__journal_priority_keyword"]
        target_label  = "level"
      }
      rule {
        source_labels = ["__journal__hostname"]
        target_label  = "instance"
      }
    }
    loki.source.journal "read" {
      forward_to = [
        loki.write.local.receiver,
      ]
      relabel_rules = loki.relabel.journal.rules
      labels = {
        "job" = "integrations/node_exporter",
      }
    }
    discovery.docker "linux" {
      host = "${docker_socket}"
    }
    discovery.relabel "logs_integrations_docker" {
        targets = []
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
      targets = discovery.docker.linux.targets
      relabel_rules = discovery.relabel.logs_integrations_docker.rules
      labels = {}
      forward_to = [
        loki.write.local.receiver,
      ]
    }
  '';

  ### gpu exporter
  environment.systemPackages = [pkgs.prometheus-nvidia-gpu-exporter];
  systemd.services.prometheus-nvidia-gpu-exporter = {
    wantedBy = ["multi-user.target"];
    after = ["network.target" "alloy.service"];
    serviceConfig = {
      ExecStart = "${pkgs.prometheus-nvidia-gpu-exporter}/bin/nvidia_gpu_exporter --web.listen-address 127.0.0.1:9835 --web.telemetry-path /metrics --nvidia-smi-command /run/current-system/sw/bin/nvidia-smi --query-field-names AUTO --log.level info --log.format json";
      Restart = "on-failure";
      RestartSec = "5s";
      RemainAfterExit = true;
    };
  };
}
