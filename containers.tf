resource "synology_container" "sabnzbd" {
  name            = "sabnzbd"
  image           = "docker.io/linuxserver/sabnzbd:latest"
  
  # Ensure volume2 exists before deploying container
  depends_on = [synology_volume.volume2]
  
  # Port mappings
  port_mappings {
    container_port = 8080
    host_port      = 8080
    protocol       = "tcp"
  }
  
  # Environment variables
  environment_variables = {
    PUID = "1000"
    PGID = "1000"
    TZ   = "America/New_York"
  }
  
  # Volume mappings
  volume_mappings {
    host_path      = "/volume1/docker/sabnzbd/config"
    container_path = "/config"
    read_only      = false
  }
  
  volume_mappings {
    host_path      = "/volume2/downloads/incomplete"
    container_path = "/incomplete-downloads"
    read_only      = false
  }
  
  volume_mappings {
    host_path      = "/volume2/downloads/complete"
    container_path = "/downloads"
    read_only      = false
  }
  
  # Auto-restart policy
  restart_policy = "unless-stopped"
  
  # Enable auto-start
  auto_start = true
}
