
output "okd_entra_id_oidc_config" {
  description = "A map of containing the issuer_url, client_id, and client_secret for Entra ID SSO for OKD/OpenShift OAuth."
  sensitive   = true
  value = {
    client_id     = azuread_application_registration.okd_cluster_app.client_id
    client_secret = azuread_application_password.okd_cluster_client_secret.value
    issuer_url    = "https://login.microsoftonline.com/${data.azuread_client_config.current.tenant_id}/v2.0"
  }
}
