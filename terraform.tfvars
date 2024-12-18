# Proxmox Provider Configuration
proxmox_url           = "https://proxmox.example.com:8006/api2/json"
proxmox_user          = "terraform-prov@pve"
proxmox_password      = "change-me-to-your-secure-password"
proxmox_tls_insecure  = true    # Set to false in production

# Node Configuration
proxmox_node          = "pve"

# Storage Configuration
storage_pool          = "local-lvm"
storage_pool_type     = "lvm"

# Network Configuration
bridge_name           = "vmbr0"

# Default VM Configuration
default_vm_memory     = 2048     # 2 GB RAM
default_vm_cores      = 2        # 2 CPU cores
default_vm_sockets    = 1        # 1 CPU socket
default_disk_size     = 32       # 32 GB disk

# Tags and Metadata
environment           = "dev"     # Change to 'staging' or 'prod' as needed
project               = "terraform-proxmox-demo"