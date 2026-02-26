# Synology Container Manager Terraform

Terraform configuration for managing Docker containers on Synology DSM using the [synology-community/synology](https://registry.terraform.io/providers/synology-community/synology/latest) provider.

## Overview

This project deploys containers on a Synology NAS:

| Service | Port | Description |
|---------|------|-------------|
| **SABnzbd** | 8080 | Usenet download client |

## Prerequisites

- Terraform >= 1.12.0
- Ansible (for directory setup)
- Synology NAS with DSM and Container Manager installed
- A Synology user account with permissions to manage containers
- Terraform Cloud account (configured for remote state)

## Getting Started

### 1. Clone the Repository

```bash
git clone <repository-url>
cd synology-cm-terraform
```

### 2. Configure Terraform Cloud

This project uses Terraform Cloud for state management. Update `provider.tf` with your organization and workspace:

```hcl
cloud {
  organization = "your-organization"
  workspaces {
    name = "your-workspace"
  }
}
```

### 3. Set Up Authentication

The Synology provider requires credentials. Set the password as an environment variable:

```bash
export TF_VAR_synology_password="your-password"
```

Or configure it in Terraform Cloud as a sensitive variable.

Update the `host` and `user` values in `provider.tf` to match your Synology NAS:

```hcl
provider "synology" {
  host            = "https://your-nas-hostname:5001"
  user            = "your-username"
  skip_cert_check = true  # Set to false if using valid SSL certificate
}
```

### 4. Initialize Terraform

```bash
terraform init
```

### 5. Review the Plan

```bash
terraform plan
```

### 6. Create Required Directories

All containers use bind mounts, so the required directories must exist before deploying. Use the included Ansible playbook to create them automatically:

```bash
# Copy and configure the inventory
cp ansible/inventory.yml.example ansible/inventory.yml

# Run the playbook
ansible-playbook -i ansible/inventory.yml ansible/create-directories.yml
```

The playbook creates all directories with the correct ownership (UID 1027, GID 100) to match the container configurations.

Alternatively, SSH into your Synology NAS and create the directories manually:

```bash
# Container config directory
sudo mkdir -p /volume1/docker/sabnzbd/config

# Media directories
sudo mkdir -p /volume1/media/movies
sudo mkdir -p /volume1/media/tv
sudo mkdir -p /volume1/media/downloads/incomplete
sudo mkdir -p /volume1/media/downloads/complete
sudo mkdir -p /volume1/media/downloads/complete/movies
sudo mkdir -p /volume1/media/downloads/complete/tv

# Set ownership
sudo chown -R 1027:100 /volume1/docker /volume1/media
```

| Directory | Used By | Purpose |
|-----------|---------|---------|
| `/volume1/docker/sabnzbd/config` | SABnzbd | Application configuration |
| `/volume1/media/movies` | Media library | Movie library |
| `/volume1/media/tv` | Media library | TV series library |
| `/volume1/media/downloads/incomplete` | SABnzbd | In-progress downloads |
| `/volume1/media/downloads/complete` | SABnzbd | Completed downloads |
| `/volume1/media/downloads/complete/movies` | Media library | Completed movie downloads |
| `/volume1/media/downloads/complete/tv` | Media library | Completed TV downloads |

### 7. Apply the Configuration

```bash
terraform apply
```

## Configuration

### Environment Variables

All containers are configured with:
- `PUID=1027` - User ID for file permissions
- `PGID=100` - Group ID for file permissions
- `TZ=America/New_York` - Timezone

Adjust these values in each `.tf` file to match your Synology user/group IDs.

### Volume Mappings

All containers use bind mounts for persistent storage. The directories must exist on the NAS before deploying the containers.

## File Structure

```
.
├── provider.tf                        # Terraform and provider configuration
├── variables.tf                       # Variable definitions
├── sabnzbd.tf                         # SABnzbd container project
└── ansible/
    ├── create-directories.yml         # Playbook to create required directories
    └── inventory.yml.example          # Example inventory file
```

## Troubleshooting

### Container not starting
- Verify the required directories exist on the NAS
- Check that PUID/PGID match a valid user with appropriate permissions
- Review container logs in Synology Container Manager

### Cannot connect to Synology
- Ensure the NAS is reachable at the configured hostname
- Verify the user has permission to manage containers
- Check that port 5001 (DSM HTTPS) is accessible

### Permission denied errors
- Confirm PUID/PGID values match the owner of the mounted directories
- Ensure the directories have appropriate read/write permissions

## License

See [LICENSE](LICENSE) for details.
