To create the Terraform project, the files should be developed in an order that ensures the foundational elements (like variables and shared modules) are created first, followed by templates, specific environments, and the main entry point.

Here’s the **order of file creation** and prompts for each file:

---

### **1. `variables.tf` (Root Level)**  
**Prompt:**  
> Create a `variables.tf` file to define global variables for the project. Include variables for Proxmox server credentials (`proxmox_url`, `proxmox_user`, `proxmox_password`), Proxmox node, and other reusable values like storage target (`local-lvm`) and network bridge (`vmbr0`). Ensure these variables can be overridden using `terraform.tfvars`.

---

### **2. `terraform.tfvars` (Root Level)**  
**Prompt:**  
> Create a `terraform.tfvars` file to define default values for global variables, such as Proxmox URL, user, password, and node. This file should correspond to the `variables.tf` definitions and serve as a centralized place for user-provided values. Add placeholder values like `https://proxmox.example.com:8006` for testing.

---

### **3. `outputs.tf` (Root Level)**  
**Prompt:**  
> Create an `outputs.tf` file to define outputs for the root module. Include outputs like Proxmox VM IDs, container IDs, and any infrastructure metadata. Ensure these outputs are useful for downstream modules or for displaying deployment results.

---

### **4. `templates/template_definitions.tf`**  
**Prompt:**  
> Create a `template_definitions.tf` file in the `templates/` directory to define reusable Proxmox VM templates. Each template should include parameters like OS type, CPU, memory, disk size, network, and SSH key. Use a variable map to define multiple templates, and create Proxmox resources using a `for_each` loop. This file should serve as the source of truth for all template definitions.

---

### **5. `templates/variables.tf`**  
**Prompt:**  
> Create a `variables.tf` file in the `templates/` directory to define all required inputs for template definitions. Include variables for a map of templates, each containing name, OS type, CPU, memory, disk size, network, and SSH key. Ensure the structure aligns with the template resources.

---

### **6. `templates/main.tf`**  
**Prompt:**  
> Create a `main.tf` file in the `templates/` directory to implement the resources for creating VM and container templates. Use the variables defined in `template_definitions.tf` and ensure compatibility with the Proxmox Terraform provider. Include the necessary configuration for template deployment.

---

### **7. `modules/vm/variables.tf`**  
**Prompt:**  
> Create a `variables.tf` file in the `modules/vm/` directory to define the parameters needed to create a VM. Include variables for VM name, target storage, OS type, CPU cores, memory, disk size, and network bridge. Ensure these variables are reusable and fully parameterized.

---

### **8. `modules/vm/main.tf`**  
**Prompt:**  
> Create a `main.tf` file in the `modules/vm/` directory to define the Proxmox VM resource using the `proxmox_vm_qemu` resource type. Use the variables defined in the `variables.tf` file and ensure compatibility with Proxmox’s API. Add resource-specific configurations like boot order, disk size, and network bridge.

---

### **9. `modules/vm/outputs.tf`**  
**Prompt:**  
> Create an `outputs.tf` file in the `modules/vm/` directory to expose outputs like VM ID, name, and IP address. These outputs should help integrate the module into higher-level environments.

---

### **10. `modules/container/variables.tf`**  
**Prompt:**  
> Create a `variables.tf` file in the `modules/container/` directory to define parameters for creating Proxmox containers. Include variables for container name, template source, CPU cores, memory, disk size, and network bridge. Ensure it is as parameterized as the VM module.

---

### **11. `modules/container/main.tf`**  
**Prompt:**  
> Create a `main.tf` file in the `modules/container/` directory to define the Proxmox container resource using the `proxmox_lxc` resource type. Use the variables defined in the `variables.tf` file and add configuration options like network interfaces and root disk size.

---

### **12. `modules/container/outputs.tf`**  
**Prompt:**  
> Create an `outputs.tf` file in the `modules/container/` directory to expose outputs like container ID, name, and IP address for higher-level use.

---

### **13. `environments/kubernetes_cluster/main.tf`**  
**Prompt:**  
> Create a `main.tf` file in the `environments/kubernetes_cluster/` directory to deploy a Kubernetes cluster using the `vm` module. Use `for_each` to create multiple VMs with specific configurations (e.g., control plane nodes, worker nodes). Define node configurations in a variable file.

---

### **14. `environments/kubernetes_cluster/variables.tf`**  
**Prompt:**  
> Create a `variables.tf` file in the `environments/kubernetes_cluster/` directory to define all variables required for the Kubernetes cluster. Include a map for node definitions (name, CPU, memory, disk size) and variables for network configuration.

---

### **15. `environments/kubernetes_cluster/kube.tfvars`**  
**Prompt:**  
> Create a `kube.tfvars` file to define the specific Kubernetes cluster node configurations, such as the number of control plane nodes, worker nodes, and resource allocations.

---

### **16. `README.md`**  
**Prompt:**  
> Create a `README.md` file at the root of the project to document the structure, purpose, and usage of the Terraform codebase. Include instructions on how to:
> - Initialize the project (`terraform init`).
> - Plan and apply configurations.
> - Add new environments or templates.
> - Customize variables and modules.

---
### **17. `main.tf` (Root Level)**
**Prompt:**
```
Create a main.tf file at the root level to serve as the entry point for the Terraform project. This file should:
Call the templates module to create reusable VM and container templates.
Reference environment-specific configurations (e.g., Kubernetes cluster or Windows VMs) by using terraform.workspace to dynamically load the correct environment setup.
Pass shared variables like Proxmox credentials, storage, and network bridge from the root variables.tf file to all modules and environments.
Include terraform and provider blocks to initialize the Proxmox provider with credentials.
Ensure modularity by structuring each environment (kubernetes_cluster, windows_vms, etc.) as its own child module, passing necessary inputs to each module.
Example structure:

terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "~> 2.9"
    }
  }
}

provider "proxmox" {
  pm_api_url      = var.proxmox_url
  pm_user         = var.proxmox_user
  pm_password     = var.proxmox_password
  pm_tls_insecure = true
}

module "templates" {
  source = "./templates"
}

module "kubernetes_cluster" {
  source = "./environments/kubernetes_cluster"
  depends_on = [module.templates]

  # Pass in variables specific to this environment
}

module "windows_vms" {
  source = "./environments/windows_vms"
  depends_on = [module.templates]

  # Pass in variables specific to this environment
}
```

This file should act as the glue, orchestrating the deployment of templates and environments.

---

### **Final Notes**
1. After creating each file, ensure that dependencies between modules, templates, and environments are clearly defined.
2. Test each module independently before integrating it into an environment.
3. Validate the overall configuration by running:
   ```bash
   terraform validate
   terraform plan -var-file="environments/kubernetes_cluster/kube.tfvars"
   ```
4. Use `terraform fmt` for consistent formatting.