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

variable "network_bridge" {
  description = "Name of the network bridge for VM network connections"
  type        = string
  default     = "vmbr0"
}

variable "network_model" {
  description = "Network interface model (e.g., virtio, e1000, vmxnet3)"
  type        = string
  default     = "virtio"
}

# DNS Configuration
variable "dns_servers" {
  description = "List of DNS servers to use for VMs"
  type        = list(string)
  default     = ["8.8.8.8", "8.8.4.4"]
}

variable "search_domain" {
  description = "DNS search domain for VMs"
  type        = string
  default     = "local"
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

# Network VLAN Configuration
variable "vlan_tag" {
  description = "VLAN tag for network interfaces (0 for untagged)"
  type        = number
  default     = 0
}

variable "network_gateway" {
  description = "Default gateway for VM networks"
  type        = string
  default     = ""
}

variable "network_subnet_mask" {
  description = "Subnet mask for VM networks"
  type        = string
  default     = "24"
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

# Template Configuration
variable "template_storage" {
  description = "Storage location for VM templates"
  type        = string
  default     = "local"
}

variable "template_description" {
  description = "Description to add to created templates"
  type        = string
  default     = "Managed by Terraform"
}