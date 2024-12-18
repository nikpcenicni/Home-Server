variable "container_name" {
  description = "Name of the container"
  type        = string
}

variable "target_node" {
  description = "Name of the Proxmox node to create the container on"
  type        = string
}

variable "template_storage" {
  description = "Storage location of the container template"
  type        = string
}

variable "template_file" {
  description = "Name of the container template file"
  type        = string
}

variable "rootfs_storage" {
  description = "Storage location for the root filesystem"
  type        = string
}

variable "cpu_cores" {
  description = "Number of CPU cores"
  type        = number
  default     = 1
}

variable "memory" {
  description = "Amount of memory in MB"
  type        = number
  default     = 512
}

variable "disk_size" {
  description = "Size of the root disk in GB"
  type        = string
  default     = "8G"
}

variable "network_bridge" {
  description = "Name of the network bridge to attach to"
  type        = string
  default     = "vmbr0"
}

variable "ip_address" {
  description = "IP address for the container (optional)"
  type        = string
  default     = ""
}
