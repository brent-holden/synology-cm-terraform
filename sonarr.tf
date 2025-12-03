# Sonarr - TV series collection manager
resource "synology_container_project" "sonarr" {
  name = "sonarr"
  run  = true

  # Named volumes for persistent data
  volumes = {
    sonarr-config    = {}
    sonarr-tv        = {}
    sonarr-downloads = {}
  }

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
          type   = "volume"
          source = "sonarr-config"
          target = "/config"
        },
        {
          # TV library directory
          type   = "volume"
          source = "sonarr-tv"
          target = "/tv"
        },
        {
          # Completed downloads directory
          type   = "volume"
          source = "sonarr-downloads"
          target = "/downloads"
        }
      ]
    }
  }
}
