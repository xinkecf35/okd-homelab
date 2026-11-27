## This configures the "on-ramp"/client side for CloudFlare ZTA

resource "cloudflare_zero_trust_access_identity_provider" "microsoft_entra_id" {
  account_id = var.cloudflare_account_id
  name       = "Entra SSO"
  type       = "azureAD"
  config = {
    client_id        = azuread_application_registration.cloudflare_one.client_id
    client_secret    = azuread_application_password.cloudflare_one_client_secret.value
    directory_id     = data.azuread_client_config.current.tenant_id
    support_groups   = true
    email_claim_name = "email"
  }
}
