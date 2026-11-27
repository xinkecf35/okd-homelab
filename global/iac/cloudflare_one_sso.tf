## Configure Cloudflare One/ZTA to use Entra for Identity source for device onboarding/access



locals {
  cloudflare_one_scopes = [
    "openid",
    "email",
    "profile",
    "offline_access",
    "Directory.Read.All",
    "GroupMember.Read.All",
    "User.Read",
  ]
  cloudflare_one_scope_ids = [
    for scope in local.cloudflare_one_scopes : data.azuread_service_principal.msgraph.oauth2_permission_scope_ids[scope]
  ]
}


resource "time_rotating" "cloudflare_one_app_password_rotation" {
  rotation_days = 90
}

resource "azuread_application_registration" "cloudflare_one" {
  display_name = "Cloudflare One - ${var.cloudflare_zero_trust_team_name}"
  description  = "Entra tenant for CloudFlare One/ZTA ${var.cloudflare_zero_trust_team_name} to ${var.okd_entra_app_name}"
}

resource "azuread_service_principal" "cloudflare_one" {
  client_id = azuread_application_registration.cloudflare_one.client_id
}

resource "azuread_application_owner" "cloudflare_one_admin" {
  application_id  = azuread_application_registration.cloudflare_one.id
  owner_object_id = data.azuread_client_config.current.object_id
}

resource "msgraph_resource" "cloudflare_one_app_password_policy_attachment" {
  url         = "applications/${azuread_application_registration.cloudflare_one.object_id}/appManagementPolicies/$ref"
  api_version = "v1.0"

  body = {
    "@odata.id" = "https://graph.microsoft.com/v1.0/policies/appManagementPolicies/${msgraph_resource.allow_opaque_client_secret.output.policy_id}"
  }
}

resource "azuread_application_password" "cloudflare_one_client_secret" {
  application_id = azuread_application_registration.cloudflare_one.id

  rotate_when_changed = {
    expiration_time = time_rotating.cloudflare_one_app_password_rotation.id
  }

  depends_on = [msgraph_resource.cloudflare_one_app_password_policy_attachment]
}

resource "azuread_application_redirect_uris" "cloudflare_one" {
  application_id = azuread_application_registration.cloudflare_one.id
  type           = "Web"

  redirect_uris = [
    "https://${var.cloudflare_zero_trust_team_name}.cloudflareaccess.com/cdn-cgi/access/callback"
  ]
}

resource "azuread_application_api_access" "cloudflare_one" {
  application_id = azuread_application_registration.cloudflare_one.id
  api_client_id  = data.azuread_application_published_app_ids.well_known.result["MicrosoftGraph"]


  scope_ids = local.cloudflare_one_scope_ids
}

resource "azuread_application_optional_claims" "cloudflare_one_token_claims" {
  application_id = azuread_application_registration.cloudflare_one.id

  id_token {
    name      = "email"
    essential = true
  }

  id_token {
    name      = "preferred_username"
    essential = true
  }

  id_token {
    name      = "given_name"
    essential = true
  }
}
