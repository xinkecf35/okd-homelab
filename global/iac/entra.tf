locals {
  cluster_ingress_domain   = "apps.${var.okd_cluster_name}.${var.okd_cluster_base_domain}"
  cluster_console_url      = "https://console-openshift-console.${local.cluster_ingress_domain}"
  oauth_entra_redirect_uri = "https://oauth-openshift.${local.cluster_ingress_domain}/oauth2callback/entra"
}


resource "time_rotating" "app_password_rotation" {
  rotation_days = 90
}

resource "azuread_application_registration" "okd_cluster_app" {
  display_name = var.okd_entra_app_name
  description  = "Entra tenant for OKD cluster ${var.okd_entra_app_name} for OIDC/SSO"
  homepage_url = local.cluster_console_url
}

resource "azuread_application_owner" "admin" {
  application_id  = azuread_application_registration.okd_cluster_app.id
  owner_object_id = data.azuread_client_config.current.object_id
}

resource "azuread_application_password" "okd_cluster_client_secret" {
  application_id = azuread_application_registration.okd_cluster_app.id

  rotate_when_changed = {
    expiration_time = time_rotating.app_password_rotation.id
  }
}

resource "azuread_application_redirect_uris" "okd_oauth_redirect_uris" {
  application_id = azuread_application_registration.okd_cluster_app.id
  type           = "Web"

  redirect_uris = [
    local.oauth_entra_redirect_uri
  ]
}

resource "azuread_application_api_access" "okd_user_profile_read" {
  application_id = azuread_application_registration.okd_cluster_app.id
  api_client_id  = data.azuread_application_published_app_ids.well_known.result["MicrosoftGraph"]


  scope_ids = [
    data.azuread_service_principal.msgraph.oauth2_permission_scope_ids["User.Read"],
    data.azuread_service_principal.msgraph.oauth2_permission_scope_ids["email"],
    data.azuread_service_principal.msgraph.oauth2_permission_scope_ids["profile"]
  ]
}

resource "azuread_application_optional_claims" "okd_oauth_id_token_claims" {
  application_id = azuread_application_registration.okd_cluster_app.id

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
