# Proxmox Provider Variables
variable "proxmox_url" {
  description = "The URL of the Proxmox API endpoint"
  type        = string
  sensitive   = false
}

variable "proxmox_user" {
  description = "Username for Proxmox authentication"
  type        = string
  sensitive   = false
}

variable "proxmox_password" {
  description = "Password for Proxmox authentication"
  type        = string
  sensitive   = true
}

variable "proxmox_tls_insecure" {
  description = "Set to true to skip TLS verification"
  type        = bool
  default     = false
}

# Node Configuration
variable "proxmox_node" {
  description = "Name of the Proxmox node to create VMs on"
  type        = string
}

# Storage Configuration
variable "storage_pool" {
  description = "Name of the storage pool to use for VM disks"
  type        = string
  default     = "local-lvm"
}

variable "storage_pool_type" {
  description = "Type of storage pool (e.g., lvm, zfs, directory)"
  type        = string
  default     = "lvm"
}

# Network Configuration
variable "bridge_name" {
  description = "Name of the network bridge to use for VM network interfaces"
  type        = string
  default     = "vmbr0"
}

# Default VM Configuration
variable "default_vm_memory" {
  description = "Default memory size in MB for VMs"
  type        = number
  default     = 2048
}

variable "default_vm_cores" {
  description = "Default number of CPU cores for VMs"
  type        = number
  default     = 2
}

variable "default_vm_sockets" {
  description = "Default number of CPU sockets for VMs"
  type        = number
  default     = 1
}

variable "default_disk_size" {
  description = "Default disk size in GB for VM root volume"
  type        = number
  default     = 32
}

# Tags and Metadata
variable "environment" {
  description = "Environment tag (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "project" {
  description = "Project name for resource tagging"
  type        = string
}
