# FileFlows container for automated file processing/transcoding
# Provides media file processing with web interface
resource "synology_container_project" "fileflows" {
  name = "fileflows"
  run  = true

  services = {
    fileflows = {
      image          = "docker.io/revenz/fileflows:latest"
      container_name = "fileflows"
      restart        = "unless-stopped"

      # Network configuration - expose web interface
      ports = [
        {
          target    = 5000 # FileFlows web interface port
          published = "19200"
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
          # Configuration/data files (persistent across container restarts)
          type   = "bind"
          source = "/volume1/docker/fileflows/data"
          target = "/app/Data"
        },
        {
          # Logs directory
          type   = "bind"
          source = "/volume1/docker/fileflows/logs"
          target = "/app/Logs"
        },
        {
          # Temporary processing directory
          type   = "bind"
          source = "/volume1/docker/fileflows/temp"
          target = "/temp"
        },
        {
          # Media library for processing
          type   = "bind"
          source = "/volume1/media"
          target = "/media"
        }
      ]
    }
  }
}
