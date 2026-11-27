terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.25"
    }
    msgraph = {
      source = "microsoft/msgraph"
    }
    time = {
      source = "hashicorp/time"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}

provider "azuread" {}

# Create App Management Policy for Entra to allow app passwords as a lot of integrations
# expect an opaque client secret

resource "msgraph_resource" "allow_opaque_client_secret" {
  url         = "policies/appManagementPolicies"
  api_version = "v1.0"

  body = {
    displayName = "Allow App Passwords/Opaque Client Secrets"
    description = "Exceptions for applications/integration requiring opaque client secrets"
    isEnabled   = true

    restrictions = {
      passwordCredentials = [
        {
          "restrictionType"                     = "passwordAddition",
          "state"                               = "disabled",
          "maxLifetime"                         = null,
          "restrictForAppsCreatedAfterDateTime" = "2020-01-01T00:00:00Z"
        },
      ]
      keyCredentials = [],
    }
  }

  response_export_values = {
    policy_id = "id"
  }

  # Add this as suggested by ChatGPT since I might 
  # manually attach this to other apps managed outside of this
  lifecycle {
    prevent_destroy = true
  }
}
