# Terraform configuration for Synology DSM management
# This configuration sets up the Synology provider to manage DSM resources

terraform {

  cloud {
    organization = "eventide"
    workspaces {
      name = "synology-cm-terraform"
    }
  }

  required_version = ">= 1.12.0"

  required_providers {
    synology = {
      source  = "synology-community/synology"
      version = "~> 0.5.1"  # Use compatible version 1.x
    }
  }
}

# Configure the Synology provider with DSM connection details
provider "synology" {
  host     = "https://endurance.lan.eventide.network:5001" 
  user     = "brent"
  skip_cert_check    = true
}
