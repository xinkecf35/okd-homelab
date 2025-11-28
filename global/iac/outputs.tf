
output "okd_entra_id_issuer_url" {
  description = "The Issuer URL for Entra ID SSO."
  value = "https://login.microsoftonline.com/${data.azuread_client_config.current.tenant_id}/v2.0"
}

output "okd_entra_id_client_id" {
  description = "Application ID/Client ID for Entra ID SSO. For use with OpenShift OAuth."
  value       = azuread_application_registration.okd_cluster_app.client_id
}

output "okd_entra_id_client_secret" {
  description = "Application Password/Client Secret for Entra ID SSO. For use with OpenShift OAuth."
  value       = azuread_application_password.okd_cluster_client_secret.value
  sensitive  = true
}
