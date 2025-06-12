# Create volume2 for storing downloads and media files
# This volume uses Btrfs filesystem with SHR for redundancy
resource "synology_volume" "volume2" {
  name        = "volume2"
  location    = "/volume2"     # Mount point on the NAS
  file_system = "btrfs"        # Modern filesystem with snapshot support
  
  # Allocation settings - use most of the available space
  allocation_type = "allocate_percentage"
  size_percentage = 95         # Reserve 5% for system overhead
  
  # RAID configuration for data protection
  raid_type = "shr"           # Synology Hybrid RAID for flexibility
  
  # Optional: Specify storage pool if you have multiple pools
  # storage_pool = "default"
}

resource "synology_folder" "downloads" {
  name   = "downloads"
  path   = "/volume2/downloads"
  
  depends_on = [synology_volume.volume2]
}

resource "synology_folder" "downloads_complete" {
  name   = "complete"
  path   = "/volume2/downloads/complete"
  
  depends_on = [synology_folder.downloads]
}

resource "synology_folder" "downloads_incomplete" {
  name   = "incomplete"
  path   = "/volume2/downloads/incomplete"
  
  depends_on = [synology_folder.downloads]
}