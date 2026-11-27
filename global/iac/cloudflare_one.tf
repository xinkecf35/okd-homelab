## This configures the "on-ramp"/client side for CloudFlare ZTA


## SSO integration to allow clients to enroll in. This is more or less the default example just to get things going
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

resource "cloudflare_zero_trust_access_policy" "allow_company_emails" {
  account_id = var.cloudflare_account_id
  name       = "Allow company emails from Entra tenant"
  decision   = "allow"
  include = [
    for email_domain in var.cloudflare_zero_trust_allow_email_domains :
    {
      email_domain = {
        domain = "@${email_domain}"
      }
    }
  ]
}

resource "cloudflare_zero_trust_access_application" "device_enrollment" {
  account_id                = var.cloudflare_account_id
  type                      = "warp"
  name                      = "Warp device enrollment"
  allowed_idps              = [cloudflare_zero_trust_access_identity_provider.microsoft_entra_id.id]
  auto_redirect_to_identity = true
  policies = [
    {
      id         = cloudflare_zero_trust_access_policy.allow_company_emails.id
      precedence = 1
    }
  ]
}
