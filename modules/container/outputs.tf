output "container_id" {
  description = "The ID of the created container"
  value       = proxmox_lxc.container.id
}

output "container_name" {
  description = "The name of the created container"
  value       = proxmox_lxc.container.hostname
}

output "ip_address" {
  description = "The IP address of the container"
  value       = proxmox_lxc.container.network[0].ip
}