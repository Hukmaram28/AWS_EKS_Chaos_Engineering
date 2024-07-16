provider "vault" {
  address          = var.vault_details.address
  skip_child_token = var.vault_details.skip_child_token

  auth_login {
    path = var.vault_details.auth_login_path

    parameters = {
      role_id   = var.vault_details.role_id
      secret_id = var.vault_details.secret_id
    }
  }
}

data "vault_kv_secret_v2" "crypteye" {
  mount = var.vault_details.mount
  name = var.vault_details.secret_name
}

output "db_password" {
  value = data.vault_kv_secret_v2.crypteye.data["db_password"]
  sensitive = true
}