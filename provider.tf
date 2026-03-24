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
      version = "~> 0.6.9"
    }
  }
}

# Configure the Synology provider with DSM connection details
provider "synology" {
  host     = "https://endurance.jackal-in.ts.net:5001" 
  user     = "brent"
  skip_cert_check    = true
}
