resource "synology_container_project" "nomad" {
  name = "nomad"
  run  = true

  services = {
    nomad-server = {
      image          = "docker.io/hashicorp/nomad:2.0"
      container_name = "nomad-server"
      restart        = "unless-stopped"
      command        = ["agent", "-config=/nomad/config"]
      network_mode   = "host"

      environment = {
        TZ                           = "America/New_York"
        NOMAD_SKIP_DOCKER_IMAGE_WARN = "true"
      }

      volumes = [
        {
          type   = "bind"
          source = "/volume1/docker/nomad/config"
          target = "/nomad/config"
        },
        {
          type   = "bind"
          source = "/volume1/docker/nomad/data"
          target = "/nomad/data"
        }
      ]
    }
  }
}
