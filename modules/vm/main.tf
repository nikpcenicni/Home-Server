resource "proxmox_vm_qemu" "vm" {
  name        = var.vm_name
  target_node = var.target_node
  clone       = var.template_name
  
  # VM Hardware configuration
  cores    = var.cpu_cores
  sockets  = 1
  memory   = var.memory
  scsihw   = "virtio-scsi-pci"
  bootdisk = "scsi0"

  # Disk configuration
  disk {
    size    = var.disk_size
    type    = "scsi"
    storage = var.target_storage
  }

  # Network configuration
  network {
    model   = "virtio"
    bridge  = var.network_bridge
  }

  # OS configuration
  os_type  = "cloud-init"
  ipconfig0 = var.ip_address != "" ? "ip=${var.ip_address},gw=${var.gateway}" : "ip=dhcp"

  # Cloud-init settings
  ciuser     = "admin"
  sshkeys    = file("~/.ssh/id_rsa.pub")
  
  # Lifecycle settings
  lifecycle {
    ignore_changes = [
      network,
      disk,
    ]
  }
}