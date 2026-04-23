node_name  = "endurance.lan.eventide.network"
datacenter = "dc1"
data_dir   = "/consul/data"
bind_addr  = "0.0.0.0"
client_addr = "0.0.0.0"

server           = true
bootstrap_expect = 1

ui_config {
  enabled = true
}

connect {
  enabled = true
}

ports {
  dns = 53
}

enable_local_script_checks = true

advertise_addr = "192.168.0.5"

telemetry {
  prometheus_retention_time = "60s"
}
