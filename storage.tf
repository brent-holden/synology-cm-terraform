resource "synology_volume" "volume2" {
  name        = "volume2"
  location    = "/volume2"
  file_system = "btrfs"
  
  # Use 95% of available storage pool space
  allocation_type = "allocate_percentage"
  size_percentage = 95
  
  # Set RAID type to SHR (Synology Hybrid RAID)
  raid_type = "shr"
  
  # Optional: Specify storage pool if you have multiple pools
  # storage_pool = "default"
}