# Radarr - Movie collection manager
resource "synology_container_project" "radarr" {
  name = "radarr"
  run  = true

  services = {
    radarr = {
      image          = "docker.io/linuxserver/radarr:latest"
      container_name = "radarr"
      restart        = "unless-stopped"

      # Network configuration - expose web interface
      ports = [
        {
          target    = 7878
          published = "7878"
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
          source = "/volume1/docker/radarr/config"
          target = "/config"
        },
        {
          # Movies library directory
          type   = "bind"
          source = "/volume1/media/movies"
          target = "/movies"
        },
        {
          # Completed downloads directory
          type   = "bind"
          source = "/volume1/media/downloads/complete/movies"
          target = "/downloads"
        }
      ]
    }
  }
}
