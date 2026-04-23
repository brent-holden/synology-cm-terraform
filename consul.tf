resource "synology_container_project" "consul" {
  name = "consul"
  run  = true

  services = {
    consul-server = {
      image          = "docker.io/hashicorp/consul:1.22"
      container_name = "consul-server"
      restart        = "unless-stopped"
      entrypoint     = ["consul"]
      command        = ["agent", "-config-dir=/consul/config"]
      network_mode   = "host"

      environment = {
        TZ = "America/New_York"
      }

      volumes = [
        {
          type   = "bind"
          source = "/volume1/docker/consul/config"
          target = "/consul/config"
        },
        {
          type   = "bind"
          source = "/volume1/docker/consul/data"
          target = "/consul/data"
        }
      ]
    }
  }
}
