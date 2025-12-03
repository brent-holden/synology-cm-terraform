# Overseerr - Media request management
resource "synology_container_project" "overseerr" {
  name = "overseerr"
  run  = true

  # Named volumes for persistent data
  volumes = {
    overseerr-config = {}
  }

  services = {
    overseerr = {
      image          = "docker.io/linuxserver/overseerr:latest"
      container_name = "overseerr"
      restart        = "unless-stopped"

      # Network configuration - expose web interface
      ports = [
        {
          target    = 5055
          published = "5055"
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
          source = "overseerr-config"
          target = "/config"
        }
      ]
    }
  }
}
