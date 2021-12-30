# Local Input Variables
locals {
  owners               = var.vm_settings.general.owner
  environment          = var.vm_settings.general.environment
  project              = var.vm_settings.general.project_name
  resource_name_prefix = "${local.project}-${local.environment}"
  common_tags = {
      project     = local.project
      owners      = local.owners
      environment = local.environment
  }
}


# PUBLIC STATIC IP
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address
resource "google_compute_address" "public_instance_static_ip" {
  count = var.vm_settings.ip_cfg.has_public_ip ? 1 : 0
  name = "${var.vm_settings.vm_cfg.name}-static-ip"
}


# PUBLIC VM INSTANCE
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance
# Adding SSH Keys - https://stackoverflow.com/questions/38645002/how-to-add-an-ssh-key-to-an-gcp-instance-using-terraform
# https://aws.amazon.com/blogs/security/securely-connect-to-linux-instances-running-in-a-private-amazon-vpc/
resource "google_compute_instance" "public_instance" {

  name         = var.vm_settings.vm_cfg.name
  //hostname     = var.vm_settings.vm_cfg.computer_name 
  machine_type = var.vm_settings.vm_cfg.machine_type
  zone         = var.vm_settings.vm_cfg.zone

  tags = var.vm_settings.vm_cfg.tags

  boot_disk {
    initialize_params {
      image = var.vm_settings.vm_cfg.image
    }
  }

  # metadata_startup_script = file("filename.sh")

  metadata = {
      "ssh-keys" = "${var.vm_settings.vm_cfg.admin_ssh_key}"
    }

  network_interface {
    network    = var.vpc_id
    subnetwork = var.subnet_id 

     access_config {
       network_tier = var.vm_settings.ip_cfg.has_public_ip ? "PREMIUM" : null
       nat_ip       = var.vm_settings.ip_cfg.has_public_ip ? google_compute_address.public_instance_static_ip[0].address : null
     }
  }
}