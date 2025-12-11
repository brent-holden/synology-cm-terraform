# Sensitive variables for container deployments
# These should be set via environment variables (TF_VAR_*) or a .tfvars file

variable "postgres_password" {
  description = "Password for the PostgreSQL database used by netvisor"
  type        = string
  sensitive   = true
}
