# Radarr - Movie collection manager
resource "synology_container_project" "radarr" {
  name = "radarr"
  run  = true

  # Named volumes for persistent data
  volumes = {
    radarr-config    = {}
    radarr-movies    = {}
    radarr-downloads = {}
  }

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
          type   = "volume"
          source = "radarr-config"
          target = "/config"
        },
        {
          # Movies library directory
          type   = "volume"
          source = "radarr-movies"
          target = "/movies"
        },
        {
          # Completed downloads directory
          type   = "volume"
          source = "radarr-downloads"
          target = "/downloads"
        }
      ]
    }
  }
}
