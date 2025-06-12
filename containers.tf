# SABnzbd container for Usenet downloads
# Provides automated binary newsgroup downloading with web interface
resource "synology_container" "sabnzbd" {
  name  = "sabnzbd"
  image = "docker.io/linuxserver/sabnzbd:latest"  # LinuxServer.io maintained image
  
  # Dependency management - ensure storage is available first
  depends_on = [synology_volume.volume2]
  
  # Network configuration - expose web interface
  port_mappings {
    container_port = 8080  # SABnzbd web interface port
    host_port      = 8080  # Accessible at http://nas-ip:8080
    protocol       = "tcp"
  }
  
  # Container environment setup
  environment_variables = {
    PUID = "1000"             # User ID for file permissions
    PGID = "1000"             # Group ID for file permissions  
    TZ   = "America/New_York" # Timezone for logging and scheduling
  }
  
  # Persistent storage mappings
  # Configuration files (persistent across container restarts)
  volume_mappings {
    host_path      = "/volume1/docker/sabnzbd/config"
    container_path = "/config"
    read_only      = false
  }
  
  # Incomplete downloads temporary storage
  volume_mappings {
    host_path      = "/volume2/downloads/incomplete"
    container_path = "/incomplete-downloads"
    read_only      = false
  }
  
  # Completed downloads final destination
  volume_mappings {
    host_path      = "/volume2/downloads/complete"
    container_path = "/downloads"
    read_only      = false
  }
  
  # Container lifecycle management
  restart_policy = "unless-stopped"  # Restart automatically except when manually stopped
  auto_start     = true              # Start container when DSM boots
}
