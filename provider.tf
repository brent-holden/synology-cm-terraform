terraform {
  required_providers {
    synology = {
      source  = "SynologyOpenSource/synology"
      version = "~> 1.0"
    }
  }
}

provider "synology" {
  host     = "192.168.0.5"
  username = "admin"
  port     = 5000  # Default DSM port
  https    = false # Set to true if using HTTPS
}
