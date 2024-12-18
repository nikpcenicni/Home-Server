variable "proxmox_api_url" {
  description = "The URL of the Proxmox API"
  type        = string
}

variable "proxmox_api_token_id" {
  description = "Proxmox API token ID"
  type        = string
}

variable "proxmox_api_token_secret" {
  description = "Proxmox API token secret"
  type        = string
  sensitive   = true
}

variable "template_node" {
  description = "Proxmox node to create templates on"
  type        = string
  default     = "pve"
}

variable "ssh_public_key" {
  description = "SSH public key to add to templates"
  type        = string
}

variable "template_storage" {
  description = "Storage location for templates"
  type        = string
  default     = "local"
}

variable "template_network_bridge" {
  description = "Network bridge to use for templates"
  type        = string
  default     = "vmbr0"
}