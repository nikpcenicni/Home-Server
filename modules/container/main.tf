resource "proxmox_lxc" "container" {
  hostname     = var.container_name
  target_node  = var.target_node
  ostemplate   = "${var.template_storage}:vztmpl/${var.template_file}"
  
  # Resource allocation
  cores    = var.cpu_cores
  memory   = var.memory
  
  # Root disk configuration
  rootfs {
    storage = var.rootfs_storage
    size    = var.disk_size
  }

  # Network configuration
  network {
    name   = "eth0"
    bridge = var.network_bridge
    ip     = var.ip_address != "" ? var.ip_address : "dhcp"
    gw     = var.ip_address != "" ? cidrhost(var.ip_address, 1) : null
  }

  # Unprivileged container
  unprivileged = true
  
  # Start on boot
  start = true

  # SSH public key for root access
  ssh_public_keys = file("~/.ssh/id_rsa.pub")
}
