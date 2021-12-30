variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "vm_settings" {
  type = object({
    general = object({
        environment  = string
        owner        = string
        project_name = string
        region       = string
    })
    vm_cfg = object({
      name          = string
      machine_type  = string
      zone          = string
      computer_name = string
      tags          = list(string)
      image         = string
      admin_ssh_key = string
    })
    ip_cfg = object({
        has_public_ip = bool
    })
  })
}