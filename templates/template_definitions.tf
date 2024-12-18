locals {
  # Define base template configurations
  template_definitions = {
    "ubuntu-2204" = {
      name        = "ubuntu-2204-template"
      os_type     = "ubuntu"
      memory      = 2048
      cores       = 2
      disk_size   = "32G"
      network     = "vmbr0"
      clone_from  = "local:iso/ubuntu-22.04-minimal-cloudimg-amd64.img"
      description = "Ubuntu 22.04 LTS Cloud Image Template"
    }
  }
}