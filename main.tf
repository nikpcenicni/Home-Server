# main.tf

terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "~> 2.9.0"
    }
  }
  
  # Optional: Configure backend for state storage
  backend "local" {
    path = "terraform.tfstate"
  }
}

# Provider configuration
provider "proxmox" {
  pm_api_url      = var.proxmox_url
  pm_user         = var.proxmox_user
  pm_password     = var.proxmox_password
  pm_tls_insecure = true # Set to false in production
  
  # Optional: Add custom API token authentication
  # pm_api_token_id     = var.api_token_id
  # pm_api_token_secret = var.api_token_secret
}

# Local variables for environment-specific configurations
locals {
  # Common configuration for all environments
  common_config = {
    target_node     = var.proxmox_node
    storage_pool    = var.storage_pool
    network_bridge  = var.network_bridge
    dns_servers     = var.dns_servers
    search_domain   = var.search_domain
  }

  # Environment-specific configurations based on workspace
  env_config = {
    dev = {
      vm_cpu_cores    = 2
      vm_memory       = 4096
      container_cores = 1
      container_memory = 2048
    }
    staging = {
      vm_cpu_cores    = 4
      vm_memory       = 8192
      container_cores = 2
      container_memory = 4096
    }
    prod = {
      vm_cpu_cores    = 8
      vm_memory       = 16384
      container_cores = 4
      container_memory = 8192
    }
  }

  # Select current environment config based on workspace
  current_env = terraform.workspace
  env = lookup(local.env_config, local.current_env, local.env_config["dev"])
}

# Templates module for creating base VM and container templates
module "templates" {
  source = "./modules/templates"
  
  proxmox_node    = local.common_config.target_node
  storage_pool    = local.common_config.storage_pool
  network_bridge  = local.common_config.network_bridge
  
  # Template-specific variables
  ubuntu_template_url     = var.ubuntu_template_url
  debian_template_url     = var.debian_template_url
  windows_template_url    = var.windows_template_url
  kubernetes_template_url = var.kubernetes_template_url
}

# # Kubernetes cluster environment
# module "kubernetes_cluster" {
#   source = "./environments/kubernetes_cluster"
#   count  = terraform.workspace == "prod" || terraform.workspace == "staging" ? 1 : 0
  
#   depends_on = [module.templates]

#   # Common configurations
#   proxmox_node   = local.common_config.target_node
#   storage_pool   = local.common_config.storage_pool
#   network_bridge = local.common_config.network_bridge
#   dns_servers    = local.common_config.dns_servers
#   search_domain  = local.common_config.search_domain

#   # Environment-specific configurations
#   control_plane_count = terraform.workspace == "prod" ? 3 : 1
#   worker_node_count   = terraform.workspace == "prod" ? 5 : 2
#   cpu_cores          = local.env.vm_cpu_cores
#   memory             = local.env.vm_memory

#   # Kubernetes-specific configurations
#   kubernetes_version = var.kubernetes_version
#   pod_cidr          = var.pod_cidr
#   service_cidr      = var.service_cidr
#   api_endpoint      = var.kubernetes_api_endpoint
# }

# # Windows VMs environment
# module "windows_vms" {
#   source = "./environments/windows_vms"
#   count  = terraform.workspace == "prod" || terraform.workspace == "staging" ? 1 : 0
  
#   depends_on = [module.templates]

#   # Common configurations
#   proxmox_node   = local.common_config.target_node
#   storage_pool   = local.common_config.storage_pool
#   network_bridge = local.common_config.network_bridge
#   dns_servers    = local.common_config.dns_servers
#   search_domain  = local.common_config.search_domain

#   # Environment-specific configurations
#   instance_count = terraform.workspace == "prod" ? 5 : 2
#   cpu_cores     = local.env.vm_cpu_cores
#   memory        = local.env.vm_memory

#   # Windows-specific configurations
#   windows_version    = var.windows_version
#   domain_join       = var.domain_join
#   domain_name       = var.domain_name
#   domain_username   = var.domain_username
#   domain_password   = var.domain_password
# }

# # Development environment
# module "development_vms" {
#   source = "./environments/development"
#   count  = terraform.workspace == "dev" ? 1 : 0
  
#   depends_on = [module.templates]

#   # Common configurations
#   proxmox_node   = local.common_config.target_node
#   storage_pool   = local.common_config.storage_pool
#   network_bridge = local.common_config.network_bridge
#   dns_servers    = local.common_config.dns_servers
#   search_domain  = local.common_config.search_domain

#   # Environment-specific configurations
#   developer_count = var.developer_count
#   cpu_cores      = local.env.vm_cpu_cores
#   memory         = local.env.vm_memory

#   # Development-specific configurations
#   dev_tools_enabled = true
#   git_config       = var.git_config
#   ide_preferences  = var.ide_preferences
# }

# # Monitoring and logging infrastructure
# module "monitoring" {
#   source = "./environments/monitoring"
#   count  = terraform.workspace == "prod" || terraform.workspace == "staging" ? 1 : 0
  
#   depends_on = [module.templates]

#   # Common configurations
#   proxmox_node   = local.common_config.target_node
#   storage_pool   = local.common_config.storage_pool
#   network_bridge = local.common_config.network_bridge
#   dns_servers    = local.common_config.dns_servers
#   search_domain  = local.common_config.search_domain

#   # Environment-specific configurations
#   instance_count = terraform.workspace == "prod" ? 3 : 1
#   cpu_cores     = local.env.container_cores
#   memory        = local.env.container_memory

#   # Monitoring-specific configurations
#   prometheus_retention = var.prometheus_retention
#   grafana_admin_pass  = var.grafana_admin_pass
#   alert_endpoints     = var.alert_endpoints
# }