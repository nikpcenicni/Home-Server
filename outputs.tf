# VM Resource Outputs
output "vm_ids" {
  description = "IDs of all created Proxmox VMs"
  value       = {
    for vm in proxmox_vm_qemu.vm :
    vm.name => vm.vmid
  }
}

output "vm_ips" {
  description = "IP addresses of all created VMs"
  value       = {
    for vm in proxmox_vm_qemu.vm :
    vm.name => vm.default_ipv4_address
  }
}

output "vm_mac_addresses" {
  description = "MAC addresses of VM network interfaces"
  value       = {
    for vm in proxmox_vm_qemu.vm :
    vm.name => vm.network[0].macaddr
  }
}

# Container Resource Outputs
output "container_ids" {
  description = "IDs of all created Proxmox containers"
  value       = {
    for ct in proxmox_lxc.container :
    ct.name => ct.vmid
  }
}

output "container_ips" {
  description = "IP addresses of all created containers"
  value       = {
    for ct in proxmox_lxc.container :
    ct.name => ct.network[0].ip
  }
}

# Resource Pool Outputs
output "pool_members" {
  description = "Members of each resource pool"
  value       = {
    for pool in proxmox_pool.pools :
    pool.pool_id => pool.members
  }
}

# Infrastructure Metadata
output "infrastructure_metadata" {
  description = "General metadata about the infrastructure"
  value = {
    environment     = var.environment
    project         = var.project
    proxmox_node    = var.proxmox_node
    storage_pool    = var.storage_pool
    network_bridge  = var.bridge_name
  }
}

# Resource Statistics
output "resource_summary" {
  description = "Summary of allocated resources"
  value = {
    total_vms       = length(proxmox_vm_qemu.vm)
    total_containers = length(proxmox_lxc.container)
    total_memory_allocated = sum([
      for vm in proxmox_vm_qemu.vm : vm.memory
    ])
    total_cores_allocated = sum([
      for vm in proxmox_vm_qemu.vm : vm.cores
    ])
  }
}

# Template Information
output "template_info" {
  description = "Information about available templates"
  value = {
    for template in data.proxmox_virtual_environment_vm.templates :
    template.name => {
      id          = template.vm_id
      description = template.description
      tags        = template.tags
    }
  }
  sensitive = false
}

# Storage Status
output "storage_status" {
  description = "Status of storage pools"
  value = {
    for storage in data.proxmox_virtual_environment_datastores.datastores.datastores :
    storage.storage => {
      type        = storage.type
      total_space = storage.total
      used_space  = storage.used
      available   = storage.available
    }
  }
}

# Network Configuration
output "network_info" {
  description = "Network configuration details"
  value = {
    bridge_name = var.bridge_name
    vms_network_config = {
      for vm in proxmox_vm_qemu.vm :
      vm.name => {
        bridge     = vm.network[0].bridge
        model      = vm.network[0].model
        macaddr    = vm.network[0].macaddr
      }
    }
  }
}