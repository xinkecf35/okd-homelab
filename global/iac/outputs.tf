
output "okd_entra_id_client_id" {
  description = "Application ID/Client ID for Entra ID SSO. For use with OpenShift OAuth."
  value       = azuread_application_registration.okd_cluster_app.client_id
}

output "okd_entra_id_client_secret" {
  description = "Application Password/Client Secret for Entra ID SSO. For use with OpenShift OAuth."
  value       = azuread_application_password.okd_cluster_client_secret.value
  sensitive  = true
}