/*
  Azure SPN creation
  - Insecure (stores clear text output in tf state)
*/

## Current azure provider
provider azurerm {
  features {}
}

provider azuread {}

variable name {
  description = "Service Principal name"
  type        = string
}

resource azuread_application app {
  name = var.name
}

resource azuread_service_principal spn {
  application_id = azuread_application.app.application_id
}

resource random_password spn_password {
  length  = 16
  special = true

  keepers = {
    service_principal = azuread_service_principal.spn.id
  }
}

resource azuread_service_principal_password spn_password {
  service_principal_id = azuread_service_principal.spn.id
  value                = random_password.spn_password.result
  end_date             = timeadd(timestamp(), "8760h")

  lifecycle {
    ignore_changes = [
      end_date
    ]
  }

  provisioner "local-exec" {
    command = "sleep 30"
  }
}

output name {
  value = azuread_service_principal.spn.display_name
}

output object_id {
  value = azuread_service_principal.spn.id
}

output application_id {
  value = azuread_service_principal.spn.application_id
}

output secret {
  sensitive = true
  value     = random_password.spn_password.result
}
