name       = "endurance.lan.eventide.network"
datacenter = "dc1"
data_dir   = "/nomad/data"
bind_addr  = "0.0.0.0"

server {
  enabled          = true
  bootstrap_expect = 1
}

client {
  enabled = false
}

advertise {
  http = "192.168.0.5"
  rpc  = "192.168.0.5"
  serf = "192.168.0.5"
}

ui {
  enabled = true
}

consul {
  address = "127.0.0.1:8500"
}

telemetry {
  publish_allocation_metrics = true
  publish_node_metrics       = true
  prometheus_metrics         = true
}
