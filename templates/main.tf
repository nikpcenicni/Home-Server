terraform {
    required_providers {
        proxmox = {
        source  = "telmate/proxmox"
        version = ">= 2.9.14"
        }
    }
}

provider "proxmox" {
    pm_api_url          = var.proxmox_api_url
    pm_api_token_id     = var.proxmox_api_token_id
    pm_api_token_secret = var.proxmox_api_token_secret
    pm_tls_insecure    = true
}

# Create VM templates
resource "proxmox_vm_qemu" "template" {
    for_each = local.template_definitions

    name        = each.value.name
    target_node = var.template_node
    clone       = each.value.clone_from
    os_type     = each.value.os_type
    memory      = each.value.memory
    cores       = each.value.cores
    scsihw      = "virtio-scsi-pci"
    onboot      = false
    template    = true

    disk {
        type    = "scsi"
        storage = var.template_storage
        size    = each.value.disk_size
        format  = "qcow2"
    }

    network {
        model  = "virtio"
        bridge = var.template_network_bridge
    }

    # Cloud-init settings
    cicustom                = "user=local:snippets/user-data-${each.key}"
    cloudinit_cdrom_storage = var.template_storage

    # Ignore changes to the clone parameter
    lifecycle {
        ignore_changes = [
        clone,
        ]
    }
}

# Create cloud-init user data files
resource "local_file" "user_data" {
    for_each = local.template_definitions

    filename = "${path.module}/files/user-data-${each.key}"
    content  = <<-EOF
        #cloud-config
        users:
        - name: terraform
            sudo: ALL=(ALL) NOPASSWD:ALL
            shell: /bin/bash
            ssh_authorized_keys:
            - ${var.ssh_public_key}
        
        package_update: true
        package_upgrade: true
        
        runcmd:
        - apt-get clean
        - apt-get autoremove
        - cloud-init clean
        EOF
}