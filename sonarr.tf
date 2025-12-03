# Sonarr - TV series collection manager
resource "synology_container_project" "sonarr" {
  name = "sonarr"
  run  = true

  services = {
    sonarr = {
      image          = "docker.io/linuxserver/sonarr:latest"
      container_name = "sonarr"
      restart        = "unless-stopped"

      # Network configuration - expose web interface
      ports = [
        {
          target    = 8989
          published = "8989"
          protocol  = "tcp"
        }
      ]

      # Network configuration - use bridge network mode
      network_mode = "bridge"

      # Container environment setup
      environment = {
        PUID = "1027"             # User ID for file permissions
        PGID = "100"              # Group ID for file permissions
        TZ   = "America/New_York" # Timezone for logging and scheduling
      }

      # Persistent storage mappings
      volumes = [
        {
          # Configuration files (persistent across container restarts)
          type   = "bind"
          source = "/volume1/docker/sonarr/config"
          target = "/config"
        },
        {
          # TV library directory
          type   = "bind"
          source = "/volume1/media/tv"
          target = "/tv"
        },
        {
          # Completed downloads directory
          type   = "bind"
          source = "/volume1/media/downloads/complete/tv"
          target = "/downloads"
        }
      ]
    }
  }
}
