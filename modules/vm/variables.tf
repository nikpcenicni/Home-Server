variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
}

variable "target_node" {
  description = "Name of the Proxmox node to create the VM on"
  type        = string
}

variable "target_storage" {
  description = "Name of the storage pool for VM disks"
  type        = string
}

variable "template_name" {
  description = "Name of the VM template to clone from"
  type        = string
}

variable "cpu_cores" {
  description = "Number of CPU cores"
  type        = number
  default     = 2
}

variable "memory" {
  description = "Amount of memory in MB"
  type        = number
  default     = 2048
}

variable "disk_size" {
  description = "Size of the primary disk in GB"
  type        = string
  default     = "32G"
}

variable "network_bridge" {
  description = "Name of the network bridge to attach to"
  type        = string
  default     = "vmbr0"
}

variable "ip_address" {
  description = "IP address for the VM (optional)"
  type        = string
  default     = ""
}

variable "gateway" {
  description = "Network gateway (optional)"
  type        = string
  default     = ""
}
