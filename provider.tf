# Terraform configuration for Synology DSM management
# This configuration sets up the Synology provider to manage DSM resources

terraform {
  required_providers {
    synology = {
      source  = "SynologyOpenSource/synology"
      version = "~> 1.0"  # Use compatible version 1.x
    }
  }
}

# Configure the Synology provider with DSM connection details
provider "synology" {
  host     = "192.168.0.5"  # IP address of your Synology NAS
  username = "admin"        # DSM administrator username
  port     = 5000          # Default DSM port (5001 for HTTPS)
  https    = false         # Set to true if using HTTPS connection
}
