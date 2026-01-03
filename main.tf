/**
    Uptime Kuma VM

    see:
      - https://uptimekuma.org/
 */
module "n8n" {
  source  = "lucidsolns/flatcar-vm/proxmox"
  version = "1.0.14"

  vm_name        = "amber.lucidsolutions.co.nz"
  vm_description = "A Flatcar VM with docker compose running n8n (nodemation) instance"
  vm_id          = var.vm_id
  node_name      = var.node_name
  tags           = ["n8n", "flatcar", "dozzle"]
  cpu = {
    cores = 2
    type  = "x86-64-v3"
  }
  memory = {
    dedicated = 2000
  }

  butane_conf         = "${path.module}/butane.tftpl"
  butane_snippet_path = "${path.module}/config"
  butane_variables = {
    DOCKER_COMPOSE_SYSEXT_VERSION="5.0.1-x86-64"
    N8N_HOST=var.n8n_host
    POSTGRES_DB="n8n"
    POSTGRES_USER="n8n"
    POSTGRES_PASSWORD=random_password.db_n8n_password.result

    # Master key used to encrypt sensitive credentials that n8n stores
    N8N_ENCRYPTION_KEY=random_password.n8n_encryption_key.result

    # Shared secret between n8n containers and runners sidecars
    N8N_RUNNERS_AUTH_TOKEN=random_password.n8n_auth_token.result

    DOZZLE_USERS_YAML_URI = module.dozzle_users.yaml_data_uri

    #  Optional timezone to set which gets used by Cron and other scheduling nodes
    #  see:
    #  - https://docs.n8n.io/hosting/configuration/environment-variables/timezone-localization/
    GENERIC_TIMEZONE=var.generic_timezone
    TZ=var.tz
  }
  bridge  = var.bridge
  vlan_id = var.vlan_id

  persistent_disks = [
    // 2 gigabytes of data for the database
    {
      datastore_id = var.storage_data
      size         = 2
      iothread     = true
      discard      = "on"
      backup       = true
    },
    // 4 GB of data for n8n
    {
      datastore_id = var.storage_data
      size         = 4
      iothread     = true
      discard      = "on"
      backup       = true
    },
    // 2 GB of data for redis
    {
      datastore_id = var.storage_data
      size         = 2
      iothread     = true
      discard      = "on"
      backup       = true
    }
  ]

  storage_images       = var.storage_images
  storage_root         = var.storage_root
  storage_path_mapping = var.storage_path_mapping
}

/*
  Generate a random password to be used for the 'n8n'' user for the db server
*/
resource "random_password" "db_n8n_password" {
  length  = 32    # number of characters
  special = false # include special chars
}

resource "random_password" "n8n_auth_token" {
  length  = 48    # number of characters
  special = false # include special chars
}

resource "random_password" "n8n_encryption_key" {
  length  = 64    # number of characters
  special = false # include special chars
}

/*
   Create a simple logging service with dozzle. This isn't persistent logging.

   see:
     - https://github.com/lucidsolns/tf-proxmox-verdant-uptime-kuma/tree/main/dozzle
*/
module dozzle_users {
  source = "git::https://github.com/lucidsolns/tf-proxmox-verdant-uptime-kuma.git//dozzle?ref=main"
}
