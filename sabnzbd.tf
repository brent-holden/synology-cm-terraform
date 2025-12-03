# SABnzbd container for Usenet downloads
# Provides automated binary newsgroup downloading with web interface
resource "synology_container_project" "sabnzbd" {
  name = "sabnzbd"
  run  = true

  # Named volumes for persistent data
  volumes = {
    sabnzbd-config              = {}
    sabnzbd-incomplete-downloads = {}
    sabnzbd-downloads           = {}
  }

  services = {
    sabnzbd = {
      image          = "docker.io/linuxserver/sabnzbd:latest"
      container_name = "sabnzbd"
      restart        = "unless-stopped"

      # Network configuration - expose web interface
      ports = [
        {
          target    = 8080 # SABnzbd web interface port
          published = "8080"
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
          source = "sabnzbd-config"
          target = "/config"
        },
        {
          # Incomplete downloads directory
          type   = "volume"
          source = "sabnzbd-incomplete-downloads"
          target = "/incomplete-downloads"
        },
        {
          # Completed downloads directory
          type   = "volume"
          source = "sabnzbd-downloads"
          target = "/downloads"
        }
      ]
    }
  }
}
