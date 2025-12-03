# Prowlarr - Indexer manager for Radarr/Sonarr
resource "synology_container_project" "prowlarr" {
  name = "prowlarr"
  run  = true

  services = {
    prowlarr = {
      image          = "docker.io/linuxserver/prowlarr:latest"
      container_name = "prowlarr"
      restart        = "unless-stopped"

      # Network configuration - expose web interface
      ports = [
        {
          target    = 9696
          published = "9696"
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
          source = "/volume1/docker/prowlarr/config"
          target = "/config"
        }
      ]
    }
  }
}
